require 'rails_helper'

RSpec.describe "People Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit people_path }
    let(:title) { t 'people.index.title' }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy'),
                           t('people.index.new')] }
    
    it_behaves_like "index page"
    
    specify "admin actions are visible for admin only" do
      create(:person)
      visit people_path
      expect(page).not_to have_links admin_actions
      sign_in
      visit people_path
      expect(page).to have_links admin_actions
    end
    
    it "should show people data" do
      person = create(:person, birth_date: build(:date),
                               death_date: build(:death_date))
      visit people_path
      expect(page).to have_link t('people.index.grave'),
                                href: grave_path(person.grave)
      expect(page).to have_link person.full_name,
                                href: person_path(person)
      expect(page).to have_contents([person.birth_date.to_s,
                                     person.death_date.to_s])
    end
  end
  
  describe "show" do
    let(:person) { create(:person, birth_date: build(:date),
                                   death_date: build(:death_date)) }
    
    let(:path) { person_path(person) }
    let(:admin_only) { [person.raw_record, person.notes, person.data_states] }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy')] }
    it_behaves_like "with admin content"
    
    it "should show the right content for plain users" do
      public_contents = Person::PUBLIC_ATTRIBUTES.map { |attr| person.send(attr) }
      visit person_path(person)
      expect(page).to have_title person.full_name
      expect(page).to have_content person.full_name
      expect(page).to have_contents public_contents
      expect(page).to have_link person.grave.name
    end
  end
end
