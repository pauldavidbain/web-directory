class PeopleController < ApplicationController
  before_filter :set_object, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    @person_presenter = PersonPresenter.new(view_context, @person)
    @bio_presenter = BiographyPresenter.new(view_context, @person.bio_edition)

    @profile_img = @person.profile_photo_url(:medium) || view_context.biola_person_image(@person.try(:biola_id), :large)
  end


  private

  def pundit_authorize
    authorize (@person || Person)
  end

end
