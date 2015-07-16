require 'spec_helper'

describe User do

  [:admin, :developer, :faculty, :student, :employee, :alumnus, :trustee, :volunteer].each do |affiliation|
    it "creates method for #{affiliation}" do
      user = FactoryGirl.build :user, affiliations: [affiliation.to_s]
      expect(user.send((affiliation.to_s + "?").to_sym)).to be true
    end
  end

  it "creates method for student worker" do
    user = FactoryGirl.build :user, affiliations: ['student worker']
    expect(user.student_worker?).to be true
  end
end
