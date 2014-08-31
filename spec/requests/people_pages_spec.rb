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
  
  describe "edit" do
    let(:person) { create :person, data_state: [:checked] }
    let(:updated_person) { attributes_for(:updated_person) }
    let(:update_txt) { "Aktualizuj osobę" }
    let(:edit_txt) { "Edytuj" }
    
    before do
      sign_in
      visit edit_person_path(person)
    end
    
    it "should update person" do
      updated_person.each do |field, value|
        fill_in simple_label(field), with: value
      end
      fill_in_date 'person_birth_date', :date
      fill_in_date 'person_death_date', :death_date
      check 'odmienione nazwisko'
      uncheck 'sprawdzone'
      click_button update_txt
      expect(page).not_to have_title edit_txt
      expect(page).to have_contents updated_person.values, 'odmienione nazwisko'
      expect(page).not_to have_content 'sprawdzone'
      click_link edit_txt
      fill_in simple_label(:family_name), with: ''
      fill_in_date 'person_death_date', :empty_date
      click_button update_txt
      expect(page).not_to have_title edit_txt
      expect(page).not_to have_contents simple_label(:family_name),
                                        simple_label(:death_date)
    end
    
    it "should display errors in form" do
      fill_in_date 'person_birth_date', :death_date
      fill_in_date 'person_death_date', :date
      fill_in simple_label(:lived), with: 'qwerty'
      click_button update_txt
      expect(page).to have_title edit_txt
      expect(page).to have_selector ".error_list"
      fill_in "person_birth_date_year", with: 1234
      fill_in simple_label(:lived), with: '123'
      click_button update_txt
      expect(page).not_to have_title edit_txt
      expect(page).to have_contents '1234', '123'
    end
    
    describe "grave select", js: true do
      let!(:quarterless) { create(:quarterless_grave) }
      let!(:g1) { create(:grave, quarter: person.grave.quarter) }
      let!(:g2) { create(:grave, quarter: g1.quarter) }
      let!(:g3) { create(:grave) }
      
      before { visit edit_person_path(person) }
      
      it "changes grave select content after selecting another quarter" do
        expect(page).to have_grave_select("", person.grave.name, g1.name, g2.name)
        select "", from: simple_label(:quarter)
        expect(page).to have_grave_select("", quarterless.name)
        select g3.quarter.name, from: simple_label(:quarter)
        expect(page).to have_grave_select("", g3.name)
        select g3.name, from: simple_label(:grave)
        click_button update_txt
        expect(page).not_to have_title edit_txt
        expect(page).to have_content g3.name
      end
    end
  end
end
