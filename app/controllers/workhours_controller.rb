#encoding: utf-8

class WorkhoursController < ApplicationController
  filter_resource_access
  respond_to :json
  
  def index
    respond_with(Workhour.all)
  end
  def show
    workhour = Workhour.find(params[:id])
    
    if workhour != nil
    respond_with(workhour)
    else
      respond_with({error: workhour.errors})
    end
  end
end