# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do 
  industry = Industry.create!(name: Faker::Name.name)
  50.times do
    Business.create!(name: Faker::Name.name, industry_id: industry.id)
  end
end