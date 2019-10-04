class CreatePathogens < ActiveRecord::Migration[5.2]
    def change 
        create_table :pathogens do |column|
            column.string :fingerprint
            column.string :disease_type
        end
    end
end