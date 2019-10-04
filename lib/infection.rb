class Infection  < ActiveRecord::Base
    belongs_to :people
    belongs_to :pathogens
end