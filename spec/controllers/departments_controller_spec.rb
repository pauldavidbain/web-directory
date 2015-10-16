require 'spec_helper'
include AuthenticationHelpers

describe DepartmentsController do

  let(:department_params) { {} }
  let(:department) { create :department, department_params }
  let(:params) { {id: department.to_param} }

  context "department has page_url" do
    let(:department_params) { { page_url: 'http://biola.edu' } }

    it "redirects to page_url" do
      get :show, params
      expect(response).to redirect_to('http://biola.edu')
    end
  end

  context "department doesn't have page_url" do
    let(:department_params) { { page_url: nil } }

    it "renders department show page" do
      get :show, params
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template("show")
      expect(assigns(:department)).to eql department
    end
  end

end
