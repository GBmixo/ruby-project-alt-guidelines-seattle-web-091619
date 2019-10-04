class Person < ActiveRecord::Base
    has_many :antibodies
    has_many :infections
    has_many :pathogens, through: :infections
    
end