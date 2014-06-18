class PeopleController < ApplicationController
  before_filter :set_person, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
  end


  private

  def set_person
    @person = Person.find(params[:id]) if params[:id]
  end

  def pundit_authorize
    authorize (@person || Person)
  end

end
