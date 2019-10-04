class Assistant
    #HELPERS
    def self.health
        x = 0
        10.times do
            x += rand(0..1)
        end
         x
    end

    def self.fingerprint
        str = ""
        pathogen_strength = rand (16..24)
        puts "----------------------------------------------------------------"
        puts "pathogen level: #{pathogen_strength}"
        pathogen_strength.times do 
            sm = rand(65..85)
             str = str + sm.chr
        end
        p str
    end

    def self.med_fingerprint
        str = ""
        2.times do 
            sm = rand(65..85)
            
             str = str + sm.chr
        end
        p str
    end

    def self.type_picker
        types = ["parasite", "virus", "bacteria", "apicomplexian",  "fungus", "cancer"]
        choose_type = rand(types.size)
        p types[choose_type].to_s
        puts "----------------------------------------------------------------"
    end

    def self.make_antibody
        str = ""
        3.times do 
            sm = rand(65..85)
             str = str + sm.chr
        end
        p str
    end

    #Update
    def self.decrease_health(person_id, direct_input = false)
        fella = Person.find(person_id)
        fealth = fella[:health]
        if fealth > 0
            fealth -= 1
            fella.update_attributes(health: fealth)
        elsif fealth <= 0
            puts "#{fella[:name]} died."
            Input.remove_person(fella[:name])
            #response = gets.chomp
            Input.new(true)
        end
        puts "----------------------------------------------------------------"
        p "#{fella[:name]} now has a health a health index of #{fella[:health]}"
        puts "----------------------------------------------------------------"

        if direct_input == true
            Input.new(true)
        end

    end

    def self.immune_prompt(fella)
        puts "----------------------------------------------------------------"
        puts "do you want to try again?"
            response = gets.chomp
            if response == "yes"
                puts "Aight"
                puts "----------------------------------------------------------------"
                Input.immune_response(fella[:name])
            elsif response == "no"
                puts "Okay then"
                puts "----------------------------------------------------------------"
                Input.new(true)
            else

            end
    end
end