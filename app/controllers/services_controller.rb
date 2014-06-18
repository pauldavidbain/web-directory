class ServicesController < ApplicationController
  before_filter :set_service, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
  end


  private

  def set_service
    @service = Service.find(params[:id]) if params[:id]
  end

  def pundit_authorize
    authorize (@service || Service)
  end
end