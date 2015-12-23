require 'rails_helper'

RSpec.describe Person, type: :model do
  it { should belong_to :grave } # forever

  let(:person) { build(:person) }
  subject { person }
  it { should be_valid }

  it { should have_one(:birth_date).dependent(:destroy) }
  it { should have_one(:death_date).dependent(:destroy) }

  it_behaves_like 'data state'

  describe 'interface' do
    fields = [:first_name, :last_name, :family_name, :lived, :description,
              :notes, :data_state, :raw_record]
    associations = [:grave, :birth_date, :death_date]
    other_methods = [:full_name]

    it { should respond_to_methods(fields, associations, other_methods) }
  end

  describe '.any_info' do
    let!(:empty) { create(:empty_person) }
    let!(:with_date) { create(:empty_person, birth_date: create(:date)) }
    let!(:only_notes) { create(:only_notes) }
    let!(:only_description) { create(:only_description) }

    it 'should return only people with some publicly accessible information' do
      any_info = Person.any_info
      expect(any_info).to include(with_date)
      expect(any_info).to include(only_description)
      expect(any_info).not_to include(empty)
      expect(any_info).not_to include(only_notes)
    end
  end

  describe '#full name' do
    its(:full_name) { should eq 'Alicja Grzybowska (Piwowarczyk)' }
    specify 'is correct without family name' do
      person.family_name = nil
      expect(person.full_name).to eq 'Alicja Grzybowska'
      person.family_name = '    '
      expect(person.full_name).to eq 'Alicja Grzybowska'
      person.first_name = person.last_name = '  '
      expect(person.full_name).to eq 'Nieznane'
    end
  end

  specify "can't live negative number of years" do
    person.lived = -5
    expect(person).not_to be_valid
    person.lived = 0
    expect(person).to be_valid
  end

  specify 'must be born before dies' do
    person.birth_date = build(:date)
    person.death_date = build(:death_date, year: 1956)
    expect(person).not_to be_valid
  end
end
