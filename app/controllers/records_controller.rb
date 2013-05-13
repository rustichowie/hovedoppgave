class RecordsController < ApplicationController
  #filter_resource_access

  

  def new
    
    respond_to do |format|
      format.html # new.html.haml
      format.xml { render :xml => @card }
    end
  end


  def create
    month = params[:datepicker].partition('-').last
    year = params[:datepicker].partition('-').first
    workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ? AND approved = ?", month, year, true).order("date desc")
    Record.new.write_record(workdays)
    respond_to do |format|
        format.html { redirect_to "/export" }
        format.xml { render :xml => @card.errors, :status => :unprocessable_entity }
      end
  end
  
end
