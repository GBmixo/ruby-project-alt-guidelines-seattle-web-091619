class CreatePeople < ActiveRecord::Migration[5.2]
    def change
        create_table :people do |column|
            column.string :name
            column.integer :health
        end
    end
end