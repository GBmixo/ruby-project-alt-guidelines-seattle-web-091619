class CreateAntibodies < ActiveRecord::Migration[5.2]
    def change 
        create_table :antibodies do |column|
            column.integer :person_id
            column.string :fingerprint
        end
    end
end