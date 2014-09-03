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
    
    before { sign_in }
    
    it "should update person" do
      visit person_path(person)
      click_link edit_txt
      expect(page).to have_title edit_txt
      
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
      visit edit_person_path(person)
      expect(page).to display_errors(edit_txt, update_txt)
    end
    
    describe "grave select", js: true do
      let!(:quarterless) { create(:quarterless_grave) }
      let!(:g1) { create(:grave, quarter: person.grave.quarter) }
      let!(:g2) { create(:grave, quarter: g1.quarter) }
      let!(:g3) { create(:grave) }
      
      it "changes grave select content after selecting another quarter" do
        visit edit_person_path(person)
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
  
  describe "new" do
    let!(:grave) { create(:quarterless_grave) }
    let(:person) { attributes_for(:person) }
    let(:add_txt) { "Dodaj osobę" }
    let(:create_txt) { "Utwórz osobę" }
    
    before { sign_in }
    
    it "should create person" do
      visit people_path
      click_link add_txt
      expect(page).to have_title(add_txt)
      
      person.each do |field, value|
        fill_in simple_label(field), with: value
      end
      select grave.name, from: simple_label(:grave)
      fill_in_date 'person_birth_date', :date
      fill_in_date 'person_death_date', :death_date
      check 'sprawdzone'
      click_button create_txt
      
      expect(page).not_to have_title add_txt
      person_attrs =
        [person.values, 'sprawdzone', build(:date), build(:death_date)]
      expect(page).to have_contents person_attrs
    end
    
    it "should display errors in form" do
      visit new_person_path
      select grave.name, from: simple_label(:grave)
      expect(page).to display_errors(add_txt, create_txt)
    end
    
    describe "grave select", js: true do
      let!(:g1) { create(:grave) }
      let!(:g2) { create(:grave, quarter: g1.quarter) }
      let!(:g3) { create(:grave) }
      
      it "changes grave select content after selecting another quarter" do
        visit new_person_path
        expect(page).to have_grave_select("", grave.name)
        select g1.quarter.name, from: simple_label(:quarter)
        expect(page).to have_grave_select("", g1.name, g2.name)
        select g1.name, from: simple_label(:grave)
        click_button create_txt
        expect(page).not_to have_title add_txt
        expect(page).to have_content g1.name
      end
    end
  end
end
