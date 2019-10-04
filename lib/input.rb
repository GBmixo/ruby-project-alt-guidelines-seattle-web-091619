class Input
    def initialize(skip_start = false)
            if skip_start == true
                Input.player_input
            end
            puts "Ready. Type 'start'"
            response = gets.chomp
            if response == "start" || response == "play"
                    puts "Okay!"
                    Input.player_input
            elsif response == "end"
                exit!
                    
            else
                    puts "Please type 'start' completely in lowercase!"
                    initialize
            end
    end

    def self.sans_first_word(input)
            splinput = input.split(" ")
            sans_word = splinput.shift
            new_input = splinput.join(" ")
    end

    def self.player_input
        system "clear"
        puts "What do you do?\n - check (people/pathogens/infections/antibodies)\n - find(weak health/pathogen(id))\n - infect (person)\n - medicate (person)\n - immune response(person)\n - add person (name)\n - remove person (name)\n - add pathogen\n - remove pathogen"
        response = gets.chomp
        #system "clear"

            #CHECK
            if response.include? "check"
                command = Input.sans_first_word(response)

                    if response.include? "people"
                        Person.all.map {|person| 
                        puts "----------------------------------------------------------------"
                        #puts person
                        puts person.name
                        puts person.health
                        puts "----------------------------------------------------------------"
                        }
                    
                        puts "press enter"
                        response = gets.chomp
                        Input.new(true)

                    elsif response.include? "pathogens"
                        Pathogen.all.map {|pathogen| 
                        puts "----------------------------------------------------------------"
                        puts pathogen.fingerprint
                        puts pathogen.disease_type
                        puts "----------------------------------------------------------------"
                        }
                    
                        puts "press enter"
                        response = gets.chomp
                        Input.new(true)

                    elsif response.include? "infections"
                        Infection.all.map {|infection| 
                            puts "----------------------------------------------------------------"
                            puts infection
                            pathogen = Pathogen.find(infection[:pathogen_id])
                            fella = Person.find(infection[:person_id])
                            puts "#{fella[:name]} has a #{pathogen[:disease_type]}"
                            puts "----------------------------------------------------------------"
                        }
                    
                        puts "press enter"
                        response = gets.chomp
                        Input.new(true)

                    elsif response.include? "antibodies"
                        command = Input.sans_first_word(response)
                        person = Input.sans_first_word(command)
                        fella = Person.find_by_name( person)
                        ants =Antibody.all.select {|ant| ant.person_id == fella[:id]}
                        ants.map {|ant|
                            puts "----------------------------------------------------------------"
                            puts ant.person_id
                            puts ant.fingerprint
                            puts "----------------------------------------------------------------"
                        }

                        puts "press enter"
                        response = gets.chomp
                        Input.new(true)

                    end

            #FIND
            elsif response.include? "find"
                puts "finding..."
                command = Input.sans_first_word(response)
                Input.find(command)

            #ADD
            elsif response.include? "add"
                command = Input.sans_first_word(response)

                    if command.include? "person"
                        command2  = Input.sans_first_word(command)
                        Input.add_person(command2)

                    elsif command.include? "pathogen"
                        Input.add_pathogen

                    end

            #REMOVE
            elsif response.include? "remove"
                     command = Input.sans_first_word(response)

                    if command.include? "person"
                        command2  = Input.sans_first_word(command)
                        Input.remove_person(command2)

                    elsif command.include? "pathogen"
                        command2  = Input.sans_first_word(command)
                        Input.remove_pathogen(command2)

                    end
                
            #APPLY EFFECT ON PERSON
            elsif response.include? "medicate"
                    command2  = Input.sans_first_word(response)
                    if Person.exists?(name: command2) == false
                        puts "no such person."
                        Input.player_input
                    end
                    Input.medicate(command2)

            elsif response.include? "unhealth"
                command2  = Input.sans_first_word(response)
                if Person.exists?(name: command2) == false
                    puts "no such person."
                    Input.new(true)
                end

                fella = Person.find_by_name(command2)
                Assistant.decrease_health(fella[:id])

            elsif response.include? "immune response"
                command2  = Input.sans_first_word(response)
                p command3 = Input.sans_first_word(command2)
                Input.immune_response(command3)

            elsif response.include? "infect"
                    command2  = Input.sans_first_word(response)
                    if Person.exists?(name: command2) == false
                        puts "no such person."
                        Input.new(true)
                    end
                    Input.infect(command2)

            #SORTS
            elsif response == "sort pathogens"
                puts "you can't sort this :("

            elsif response == "end"
                    puts "----------------------------------------------------------------"
                    exit!

            else
                    puts "Not valid command"
                    puts "press enter"
                    response = gets.chomp
                    Input.new(true)
            end
    end

    #######################################
    #COMMANDS
    #######################################

    #ADD & REMOVE
    #Create
    def self.add_person(name)
        puts biological_status = Assistant.health
        puts "#{name} has a health index of #{biological_status}"
        Person.create(name: name, health: biological_status)

        puts "press enter"
        response = gets.chomp
        Input.new(true)
    end
    
    #Delete
    def self.remove_person(name)
        puts "#{name} removed" 
        fella  = Person.find_by_name(name)
        
        Infection.where(person_id: fella[:id]).destroy_all
        person = Person.where(name: name).destroy_all

        puts "press enter"
        response = gets.chomp
        Input.new(true)
    end

    #Create
    def self.add_pathogen
        
        fprint = Assistant.fingerprint
        disease = Assistant.type_picker
        Pathogen.create(fingerprint: fprint, disease_type: disease)

        puts "press enter"
        response = gets.chomp
        Input.new(true)
    end

    #Delete
    def self.remove_pathogen(fingerprint)
        #puts "#{name}" 
        disease  = Pathogen.find_by_fingerprint(fingerprint)

        Infection.where(pathogen_id: disease[:id])
        pathogen = Pathogen.where(fingerprint: fingerprint).destroy_all

        puts "press enter"
        response = gets.chomp
        Input.new(true)
    end


    #DISEASE FEATURES
    #Create
    def self.infect(person)
        fella = Person.find_by_name( person)
        num_diseases = Pathogen.maximum(:id)
        rand_disease = rand(num_diseases) + 1
        p actual_disease = Pathogen.find(rand_disease)

        fella_ants = Antibody.where(person_id: fella[:id])
        ant_fprints = []
        p ant_fingerprint = fella_ants.map{|ant| ant_fprints << ant[:fingerprint]}

        immune = false

        ant_fprints.map{|fprint|
            if actual_disease[:fingerprint].include?(fprint)
                immune = true
            end
        }

        if immune == false
            puts "----------------------------------------------------------------"
            puts disease_name = actual_disease
            Infection.create(person_id: fella[:id], pathogen_id: rand_disease)
            puts "#{person} is infected with a #{disease_name[:disease_type]}."
            puts "----------------------------------------------------------------"
        elsif immune == true
            immune = false
            puts "----------------------------------------------------------------"
            puts  "#{fella[:name]} is immune to #{actual_disease}"
            puts "----------------------------------------------------------------"
        end


        puts "press enter"
        response = gets.chomp
        Input.new(true)
    end

    #ACTIONS
    #Read
    def self.find(command)
      
        if command.include? "weak health" || "low health" || "weak people" || "sickos"
            weak_people =  Person.all.select {|person| person.health < 3}
            weak_people.map{|person|
                puts "----------------------------------------------------------------"
                puts "#{person.name}'s health: #{person.health}'"
                puts "----------------------------------------------------------------"
            }
            puts "press enter"
            response = gets.chomp
            Input.new(true)

        elsif command.include? "disease"
            command = Input.sans_first_word(response)
            pathogen_id = Pathogen.all.select {|sick| sick.id == command}

            puts "#{pathogen_id.id}"
            puts "press enter"
            response = gets.chomp
            Input.new(true)
        end
    end

    #Update
    def self.immune_response(person)
        #Person Info
        fella = Person.find_by_name( person)
        fella_health = fella[:health]
        #Infection And Disease
        infection = Infection.find_by_person_id(fella[:id])
        disease = Pathogen.find(infection[:pathogen_id])
        puts "----------------------------------------------------------------"
        puts "#{fella[:name]} has #{fella_health} health"
        puts "----------------------------------------------------------------"

        #Check  for person and infection and run antibodies
        if Infection.exists?(person_id: fella[:id]) && Person.exists?(id: fella[:id]) && fella[:health] > 0
            
            fealth = fella_health * 10
            fealth.times do 
                #Make antibodies
                p abody = Assistant.make_antibody
                if disease[:fingerprint].include? abody
                    infection.destroy
                    puts "----------------------------------------------------------------"
                    puts "Heck yeah, disease annihilated!"
                    puts "----------------------------------------------------------------"
                    Antibody.create(person_id: fella[:id], fingerprint: abody)

                    puts "press enter"
                    response = gets.chomp
                    Input.new(true)
                
                end
                
            end

        if fella[:health] > 0
            Assistant.decrease_health(fella[:id])
        end
            
        end
            
            Assistant.immune_prompt(fella)

    end

    @pill_count = 0
    #Update
    def self.medicate(person)
        
            med_print = Assistant.med_fingerprint
            p fella = Person.find_by_name(person)

            if @pill_count > fella[:health] * 3
                    puts "----------------------------------------------------------------"
                    puts "#{@pill_count} pills downed."
                    puts "#{fella[:name]} died."
                    puts "----------------------------------------------------------------"
                    Input.remove_person(fella[:name])
                    @pill_count = 0

                    puts "press enter"
                    response = gets.chomp
                    Input.new(true)
            end


            if Infection.exists?(person_id: fella[:id]) && Person.exists?(id: fella[:id])
                    #puts "infection found."
                    infection = Infection.find_by_person_id(fella[:id])
                    disease = Pathogen.find(infection[:pathogen_id])
                    #puts disease[:fingerprint]

                    if disease[:fingerprint].include? med_print
                            puts "----------------------------------------------------------------"
                            puts "#{@pill_count} pills downed."
                            infection.destroy
                            puts "Heck yeah, disease annihilated!"
                            puts "----------------------------------------------------------------"
                            @pill_count = 0

                            puts "press enter"
                            response = gets.chomp
                            Input.new(true)
                    else
                            @pill_count += 1
                            #response = gets.chomp
                            Input.medicate(fella[:name])
                    end
            else
                    puts "----------------------------------------------------------------"
                    puts"No infection or person here."
                    puts "----------------------------------------------------------------"
                    #Input.player_input
            end


            puts "press enter"
            response = gets.chomp
            Input.new(true)
    end
end