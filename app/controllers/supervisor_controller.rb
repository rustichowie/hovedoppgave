class SupervisorController < ApplicationController


  def index
  end
  
  def list
    person1 = { :id => 1, :name => "Thommas Thommassen", :date => "26.02.2013", :hours => "7,5"}
    person2 = { :id => 2, :name => "Arnold Armstrong", :date => "26.02.2013", :hours => "8,5"}
    person3 = { :id => 3, :name => "Roger Rabbit", :date => "26.02.2013", :hours => "7,0"}
    person4 = { :id => 4, :name => "Haavols Hvalross", :date => "26.02.2013", :hours => "7,0"}
    person5 = { :id => 5, :name => "Trude Trutmunn", :date => "26.02.2013", :hours => "6,0"}
    @collection = []
    @collection.push(person1)
    @collection.push(person2)
    @collection.push(person3)
    @collection.push(person4)
    @collection.push(person5)
  end
  
end
