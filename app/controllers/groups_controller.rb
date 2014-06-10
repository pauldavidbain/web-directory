class GroupsController < ApplicationController
  before_filter :set_group, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
  end


  private

  def set_group
    @group = Group.find(params[:id]) if params[:id]
  end

  def pundit_authorize
    authorize (@group || Group)
  end

end