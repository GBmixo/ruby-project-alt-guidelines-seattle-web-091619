require_relative '../config/environment'

#p1 = Person.create({name: "Derek", health: 6})
#p2 = Person.new({name: "Derek", health: 6})
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
#add person
Input.new
