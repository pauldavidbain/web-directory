class DepartmentsController < ApplicationController
  before_filter :set_department, only: [:show, :edit, :update]
  before_filter :pundit_authorize

  def show
    render_error_page(404) if @department.dont_index?
  end


  private

  def set_department
    if params[:id]
      @department = Department.any_of({id: params[:id]}, {slug: params[:id]}).first
      render_error_page(404) if @department.blank?
    end
  end

  def pundit_authorize
    authorize (@department || Department)
  end
end
