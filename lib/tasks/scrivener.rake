# encoding: utf-8

namespace :db do
  task :reset => ["db:drop", "db:migrate"]
end


# rake campo:scrivener:slurp[/path/to/file.txt]
namespace :campo do
  task "destroy_everything" => :environment do
    Choice.destroy_all
    Folder.destroy_all
    EventResponse.destroy_all
    Response.destroy_all
    FactMutation.destroy_all
    Fact.destroy_all
    Requirement.destroy_all
  end

  task "ingest_everything" => :environment do
    `rake campo:destroy_everything`

     Dir.glob('/Users/hoverbird/code/campo/p4/patrick_sax/Unity/Wyoming/Assets/_EventData/*.json').each do |filename|
       puts "Ingesting #{filename}"
       `rake campo:ingest_json[#{filename}]`
     end
  end

  task "gdoc" => :environment do
    require File.expand_path(File.dirname(__FILE__)) + '/tiny_gdoc_importer.rb'
    i = EventResponseImporter.new
    puts i.rows
  end

  task "ingest_json", [:filename] => :environment do |t, args|
    puts "Ingesting #{args[:filename]}"
    json_doc = File.read(args[:filename])

    folder_name = args[:filename].split('/').last.gsub('.json', '')
    folder = Folder.find_or_create_by_name(folder_name)

    j = JSON.parse json_doc
    event_responses = j["$values"]

    event_responses.each do |er_data|
      er = EventResponse.new({
        name: er_data['EventName'],
        folder: folder
      })

      if er_data["Requirements"] and er_data["Requirements"]["$values"]
        er_data["Requirements"]["$values"].each do |req_data|
          if req_data["Name"]
            fact = Fact.find_or_create_by_name(req_data["Name"])
            status = req_data["Status"]

            if fact.new_record?
              fact.default_value = status
            end

            requirement = Requirement.new(fact: fact)
            if !status.nil?
              requirement.comparator = req_data["comparator"]
              requirement.status = req_data["Status"]
              requirement.left_value = req_data["leftValue"]
              requirement.right_value = req_data["rightValue"]

            end
            er.requirements << requirement
          else
            warn "Null fact name: #{req_data}"
          end
        end
      end

      er.save!
      if er_data["Responses"] and er_data["Responses"]["$values"]
        er_data["Responses"]["$values"].each do |resp_data|
          begin
            response_type = resp_data["$type"]
            pp response_type.upcase
            case response_type
              when /SpeechResponse/
                speech_hash = resp_data.delete("SpeechToPlay")
                resp_data.merge!(speech_hash)
                pp resp_data
                response = SpeechResponse.create(
                  event_response: er,
                  on_finish_event_name: resp_data["OnFinishEvent"],
                  text: resp_data["Caption"],
                  on_finish_event_delay: resp_data["OnFinishEventDelay"],
                  audio_clip_path: resp_data["AudioClipPath"],
                  allow_queueing: resp_data["AllowQueueing"],
                  hack_audio_duration: resp_data["HackAudioDuration"]
                )
              when /DialogTreeResponse/
                response = DialogTreeResponse.create!(event_response: er)
                pp "*" * 200
                # require 'ruby-debug'; debugger
                choices = resp_data["DialogToShow"]["Choices"]["$values"]
                pp "Choices Found"
                pp choices.inspect
                choices.each do |choice|
                  Choice.create!(dialog_tree_response: response, event_name: choice["EventResponse"])
                end
              when /IsDialogChoiceResponse/
                choice_text = resp_data["choiceText"] || 'undefined'
                response = IsDialogChoiceResponse.create(event_response: er, text: choice_text)
              when /FactResponse/
                response = FactResponse.create(event_response: er)
                fact = Fact.find_or_create_by_name(resp_data["FactName"])
                FactMutation.create(new_value: resp_data["value"], fact: fact, fact_response: response, op: resp_data["op"])
              when /TriggerEventResponse/
                response = TriggerEventResponse.create(
                  event_response: er,
                  on_finish_event_name: resp_data["EventToTrigger"]
                )
            else
              raise "Unknown response type!! Type found: #{response_type}"
            end
          rescue => e
            raise e, "Couldn't import Response data: #{resp_data}"
          end
        end
      end

      er.save!
      pp "Created EventResponse"
      pp er.to_web_hash
    end
  end

  desc "Parse scrivener files in Sean's format and convert them to Unity-approved JSON"
  task "scrivener:slurp", [:filename] => :environment do |t, args|
    scrivener_source = File.read(args[:filename])
    folder_name = args[:filename].split('/').last.gsub('.txt', '')
    folder = Folder.find_or_create_by_name(folder_name)

    # /        - delimiter
    # \{       - opening literal brace escaped because it is a special character used for quantifiers eg {2,3}
    # (        - start capturing
    # [^}]     - character class consisting of
    #     ^    - not
    #     }    - a closing brace (no escaping necessary because special characters in a character class are different)
    # +        - one or more of the character class
    # )        - end capturing
    # \}       - the closing literal brace
    # /        - delimiter
    requirements_matcher = /\{([^}]+)\}/

    header_matcher = /^([A-Z0-9_]*)\n/
    name_matcher = /^[A-Z0-9_]*/

    choice_matcher = /^[1-9]\./

    event_name_matcher = /\[([0-9]+)\]/
    previous_event_ids_matcher = /:([0-9,])+/

    name_chunks  = scrivener_source.split(header_matcher)
    name_chunks.reject! {|c| c.empty?}

    begin
      previous_event, previous_event_id = nil, nil

      name_chunks.each_slice(2) do |header, text|

        # Pull the character name out of the header
        char = header.match(name_matcher)[0]
        header.gsub! char, ''

        # If any chars are left in the header...
        if header.present?
          previous_event_id_match = header.match(previous_event_ids_matcher)
          previous_event_ids = previous_event_id_match[1].split(',')
          header.gsub!(previous_event_id_match[0], '')

          puts "previous_event_ids, #{previous_event_ids}"
          previous_event_id = previous_event_ids.first if previous_event_ids.present?

          event_name_match = header.match(event_name_matcher)
          event_name = event_name_match[1]
          header.gsub!(event_name_match[0], '')
          puts "event_name, #{event_name}"
        end

        unless text && char
          puts ":::SKIPPING MISMATCHED PAIRS:::"
          puts "#{char}:#{text}"
          next
        end
        reqs = text.match(requirements_matcher)

        if reqs
          # take match sans braces, treat as CSV
          reqs = reqs[1].split(',').map do |reqString|
            reqString = reqString.split("=")
            fact = reqString.first.strip
            constraint = reqString.last.strip

            fact = Fact.find_or_create_by_name(fact)
            [fact, constraint]
          end
          # Remove reqs string from text
          text.gsub!(requirements_matcher, '')
        end

        response = Response.create!(
          text: text,
          character: char.humanize,
          folder: folder
        )

        event = if event_name
          Event.find_or_create_by_name!(event_name)
        else
          auto_gen_event_name = "#{response.character_slug}_response_#{response.id}"
          Event.create!(name: auto_gen_event_name)
        end

        if event.new_record?
          puts "That's a new event"
          puts event
        elsif event
          puts "Found an existing event"
          puts event
        else
          puts "No event for this response"
          puts header
        end

        response.event = event
        response.save!

        # For the next iteration
        previous_response = response


        # Reqs is now a tuple of Fact objects and requirement strings
        reqs.each do |tuple|
          puts "REQ TUPLE: #{tuple}"

          fact = Fact.find_or_create_by_name(tuple[0].name)
          puts "Found or created fact: #{fact.name}"

          requirement = Requirement.create!(
            fact: fact,
            fact_test: tuple[1],
            event: event
          )
          puts "Created constraint: #{requirement.to_json}"
        end if reqs

        puts "#{response.character} said: #{response.text}"
        event.requirements.each do |r|
          puts "IF #{r.fact.name} EQUALS #{r.fact_test}"
        end
        puts "--------------"
      end
    end
  end

  # json = `curl choice.192.168.11.13.xip.io/events/v0/unity`
  desc "Copy all Moment events into perforce"
  task "p4:update" do
    p4_target = "/Users/hoverbird/code/campo/p4/patrick_sax/Tools/ChoiceEditor/event_responses.json"
    json = `curl choice.dev/event_responses/v0/unity`
    raise "Not valid JSON: #{json}" unless JSON.parse(json)
    puts "JSON looks good! Writing to #{p4_target}"
    File.open(p4_target, 'w') { |f| f.write json }
  end
end
