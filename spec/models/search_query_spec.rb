require 'spec_helper'

def test_searchability(affiliation, searchable)
  context affiliation.to_s do
    let(:person_affiliations) { [affiliation.to_s] }
    it "is #{searchable ? '' : 'not '}searchable" do
      if searchable
        # Desired result will have the person with the given affilation
        expect(sq).to eql desired_result
      else
        # Expect the search reqult to be empty
        expect(sq).to eql []
      end
    end
  end
end

describe SearchQuery do
  let(:term) { '' }
  let(:options) { {} }
  let(:affiliations) { [] }
  let(:person_affiliations) { {} }
  let(:person_atters) { { affiliations: person_affiliations }}
  let(:person) { create(:person, person_atters) }
  let(:current_user) { create(:user) }
  let(:dont_index) { true }
  let(:desired_result) { Elasticsearch::Model.client.search({index: Settings.elasticsearch.index_name, body: {query:{match_all: {}}} })['hits']['hits'].map{|h|h['_id']} }

  before(:each) do
    Person.delete_all
    Elasticsearch::Model.client.indices.delete index: Settings.elasticsearch.index_name rescue nil

    person
    Person.__elasticsearch__.refresh_index!
  end

  subject(:sq) { SearchQuery.new(term, options.merge( current_user: current_user )).execute['hits']['hits'].map{|h|h['_id']} }

  describe 'if current_user is NOT set' do
    let(:current_user) { nil }

    test_searchability('student', false)
    test_searchability('alumnus', false)
    test_searchability('employee', false)
    test_searchability('trustee', false)
    test_searchability('volunteer', false)
    test_searchability('faculty', false)


    context 'and the person has a biography' do
      before(:each) do
        bio = person.bio_editions.create(biography: 'this is the text of my bio')
        bio.publish
        bio.save
        person.add_to_index  # todo, I feel like this should probably happen automatically when the bio is saved
        expect(person.is_public?).to be true
        Person.__elasticsearch__.refresh_index!
      end

      test_searchability('student', false)
      test_searchability('alumnus', false)
      test_searchability('employee', true)
      test_searchability('trustee', true)
      test_searchability('volunteer', false)
      test_searchability('faculty', true)
    end
  end

  describe 'if current_user is employee' do
    let(:affiliations) { ['employee'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', true)
    test_searchability('alumnus', true)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end

  describe 'if current_user is faculty' do
    let(:affiliations) { ['faculty'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', true)
    test_searchability('alumnus', true)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end

  describe 'if current_user is a trustee' do
    let(:affiliations) { ['trustee'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', false)
    test_searchability('alumnus', true)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end

describe 'if current_user is a volunteer' do
    let(:affiliations) { ['volunteer'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', false)
    test_searchability('alumnus', true)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end

  describe 'if current_user is a student' do
    let(:affiliations) { ['student'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', true)
    test_searchability('alumnus', false)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end

describe 'if current_user is a alumnus' do
    let(:affiliations) { ['alumnus'] }
    let(:current_user) { create :user, affiliations: affiliations }

    test_searchability('student', false)
    test_searchability('alumnus', true)
    test_searchability('employee', true)
    test_searchability('trustee', true)
    test_searchability('volunteer', true)
    test_searchability('faculty', true)
  end
end
