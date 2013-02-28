# encoding: utf-8
class UserController < ApplicationController
  
  def index
    @c = []
    @d = [{start: "08:00", stop: "11:30", antall: 3.5, status: "Noe"}, {start: "12:00", stop: "15:00", antall: 3, status: "Noe annet"}]
    comp1 = {id: 1, name: "Håvard", hours: 7, date: "26.02.2013", status: "bekreftet"}
    comp2 = {id: 2, name: "Håvard", hours: 7, date: "26.02.2013", status: "bekreftet"}
    comp3 = {id: 3, name: "Håvard", hours: 7, date: "26.02.2013", status: "bekreftet"}
    @c.push(comp1)
    @c.push(comp2)
    @c.push(comp3)
  end
  
  
end