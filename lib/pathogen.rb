class Pathogen  < ActiveRecord::Base
    has_many :infections
    has_many :people, through: :infections
end