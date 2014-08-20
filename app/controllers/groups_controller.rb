class GroupsController < ApplicationController
  before_filter :set_group, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    render_error_page(404) if @group.dont_index?
  end


  private

  def set_group
    if params[:id]
      @group = Group.any_of({id: params[:id]}, {slug: params[:id]}).first
      render_error_page(404) if @group.blank?
    end
  end

  def pundit_authorize
    authorize (@group || Group)
  end

end
