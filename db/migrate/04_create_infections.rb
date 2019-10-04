class CreateInfections < ActiveRecord::Migration[5.2]
    def change 
        create_table :infections do |column|
            column.integer :person_id
            column.integer :pathogen_id
        end
    end
end