require 'spec_helper'

describe PersonPolicy do
  let(:attrs) { {} }
  let(:user) { build :user, attrs }
  let(:person) { build :person }


  describe "can_see_employee_phone?" do
    subject { PersonPolicy.new(user, nil).can_see_employee_phone? }

    context "student" do
      let(:attrs) {{ affiliations: ['student'] }}
      it { should eql false }
    end

    context "student_worker" do
      let(:attrs) {{ affiliations: ['student_worker'] }}
      it { should eql true }
    end

  end
end
