# encoding: utf-8

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

    name_matcher = /^([A-Z0-9_]*)\n/
    choice_matcher = /^[1-9]\./

    name_chunks  = scrivener_source.split(name_matcher)
    name_chunks.reject! {|c| c.empty?}

    begin
      last_line = nil
      name_chunks.each_slice(2) do |char, text|
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

        moment = Moment.create!(text: text, character: char)
        # Reqs is now a tuple of Fact objects and constraint strings
        reqs.each do |tuple|
          constraint = Constraint.create!(
            fact: tuple[0],
            fact_test: tuple[1],
            moment: moment
          )
          puts "Created constraint: #{constraint.to_json}"
        end if reqs

        puts "#{moment.character} said: #{moment.text}"
        moment.constraints.each do |c|
          puts "IF #{c.fact.name} EQUALS #{c.fact_test}"
        end
        puts "--------------"
      end
    # rescue StandardError => e
    #   puts "ERROR on"
    end
  end

end
