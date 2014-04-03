# encoding: utf-8

namespace :db do
  task :reset => ["db:drop", "db:migrate"]
end

namespace :campo do
  desc "Parse scrivener files in Sean's format and convert them to Unity-approved JSON"
  task "scrivener:slurp", [:filename] => :environment do |t, args|
    scrivener_source = File.read(args[:filename])

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
          fact = Fact.find_or_create_by_name(tuple[0])
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

  desc "Copy all Moment events into perforce"
  task "p4:update" do
    p4_target = "/Users/hoverbird/code/campo/p4/patrick_sax/Tools/ChoiceEditor/event_responses.json"
    json = `curl choice.192.168.11.13.xip.io/events/v0/unity`
    raise "Not valid JSON: #{json}" unless JSON.parse(json)
    puts "JSON looks good! Writing to #{p4_target}"
    File.open(p4_target, 'w') { |f| f.write json }
  end
end
