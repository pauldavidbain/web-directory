require 'spec_helper'

describe SearchQuery do
  let(:term) { '' }
  let(:options) { {} }
  let(:affiliations) { [] }
  let(:person_affiliations) { {} }
  let(:person_atters) { { affiliations: person_affiliations }}
  let(:person) { create(:person, person_atters) }
  let(:current_user) { create(:user) }
  let(:dont_index) { true }
  let(:desired_result) { Elasticsearch::Model.client.search({index: Settings.elasticsearch.index_name, body: {query:{match_all: {}}} })['hits']['hits'] }

  before(:each) do
    Person.delete_all
    Elasticsearch::Model.client.indices.delete index: Settings.elasticsearch.index_name rescue nil

    person
    Person.__elasticsearch__.refresh_index!
  end

  subject(:sq) { SearchQuery.new(term, options.merge( current_user: current_user )) }

  describe 'if current_user is NOT set' do
    let(:current_user) { nil }

    context 'it should not return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should not return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should not return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should not return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

  describe 'if current_user is employee' do
    let(:affiliations) { ['employee'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

  describe 'if current_user is faculty' do
    let(:affiliations) { ['faculty'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

  describe 'if current_user is a trustee' do
    let(:affiliations) { ['trustee'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should not return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

describe 'if current_user is a volunteer' do
    let(:affiliations) { ['volunteer'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should not return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

  describe 'if current_user is a student' do
    let(:affiliations) { ['student'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should not return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end

describe 'if current_user is a alumnus' do
    let(:affiliations) { ['alumnus'] }
    let(:current_user) { create :user, affiliations: affiliations }

    context 'it should not return' do
      let(:person_affiliations) { ['student'] }
      it 'students' do
        expect(sq.execute['hits']['hits']).to eql []
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['alumnus'] }
      it 'alumnus' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['employee'] }
      it 'employees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['trustee'] }
      it 'trustees' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['volunteer'] }
      it 'volunteers' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end

    context 'should return' do
      let(:person_affiliations) { ['faculty'] }
      it 'faculty' do
        expect(sq.execute['hits']['hits']).to eql desired_result
      end
    end
  end
end
