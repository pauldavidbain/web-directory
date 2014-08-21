class GroupsController < ApplicationController
  before_filter :set_object, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
  end


  private

  def pundit_authorize
    authorize (@group || Group)
  end

end
