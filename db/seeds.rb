# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'authlogic/test_case' 
require "declarative_authorization/maintenance"
Authorization::Maintenance::without_access_control do
Role.find_or_create_by_id(id: 1, name: "Ansatt", description: "Vanlig ansatt")
Role.find_or_create_by_id(id: 2, name: "Formann", description: "Formann")
Role.find_or_create_by_id(id: 3, name: "Administrator", description: "Bruker med alle rettigheter")

Group.find_or_create_by_id(id: 1, name: "Admins")
#Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)
User.find_or_create_by_id(id: 1, name: "Admin", password: 'admin', password_confirmation: 'admin',
employee_id: nil, pin: "8985", email: "admin@admin.no", group_id: 1,
 role_id: 3, remote_id: nil)
end