class RecordsController < ApplicationController
  #filter_resource_access

  

  def new
    
    respond_to do |format|
      format.html # new.html.haml
      format.xml { render :xml => @card }
    end
  end


  def create
    
    workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ?", Date.today.month, Date.today.year).order("date desc")
    Record.new.write_record(workdays)
    respond_to do |format|
        format.html { redirect_to "/export" }
        format.xml { render :xml => @card.errors, :status => :unprocessable_entity }
      end
  end
  
end
