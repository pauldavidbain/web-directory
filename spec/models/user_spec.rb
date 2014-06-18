require 'spec_helper'

describe User do
  let(:attrs) { {} }
  let(:user) { build :user, attrs }


  describe "can_see_phone?" do
    subject { user.can_see_phone? }

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
