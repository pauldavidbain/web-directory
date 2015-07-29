class GroupsController < ApplicationController
  before_filter :set_object, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    # @group is set in application controller via the set object before filter
    @meta_fields = @group.meta_fields
  end


  private

  def pundit_authorize
    authorize (@group || Group)
  end

end
