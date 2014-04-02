class PeopleController < ApplicationController

  def staff
    @person = Person.find(params[:id])
  end

end