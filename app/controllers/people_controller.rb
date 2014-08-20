class PeopleController < ApplicationController
  before_filter :set_person, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    render_error_page(404) if @person.dont_index?
  end


  private

  def set_person
    if params[:id]
      @person = Person.any_of({id: params[:id]}, {slug: params[:id]}).first
      render_error_page(404) if @person.blank?
    end
  end

  def pundit_authorize
    authorize (@person || Person)
  end

end
