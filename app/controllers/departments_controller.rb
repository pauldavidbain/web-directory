class DepartmentsController < ApplicationController
  before_filter :set_object, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    @department_presenter = DepartmentPresenter.new(view_context, @department)
    @memberships = @department.memberships.where(published: true).order(order: :asc)
    @teams = @memberships.map(&:team).flatten.uniq.sort
  end


  private

  def pundit_authorize
    authorize (@department || Department)
  end
end
