require 'rails_helper'

RSpec.describe "Grave Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit graves_path }
    let(:title) { t 'graves.index.title' }
    
    it_behaves_like "index page"
    
    it "should have link to the new grave page only for admin user" do
      new_grave = t('graves.index.new')
      expect(page).not_to have_link new_grave
      sign_in
      visit graves_path
      click_link new_grave
      expect(page).to have_title new_grave
    end
    
    describe "content" do
      let!(:quarter) { create(:quarter) }
      
      it "shouldn't list quarter which has no graves" do
        expect(page).not_to have_link quarter.name
      end
      
      it "should list quarter with its graves" do
        grave = create(:grave, quarter: quarter)
        visit graves_path
        expect(page).to have_link quarter.name
        expect(page).to have_link grave.number
      end
    end
  end
  
  describe "show" do
    let(:grave) { create(:grave) }
    let(:path) { grave_path(grave) }
    let(:public_contents) { [grave.name, grave.number, grave.description] }
    let(:admin_only) { [grave.family_name, grave.notes] }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy')] }
    
    it_behaves_like "with admin content"
    
    context "as plain user" do
      before { visit grave_path(grave) }
      
      it { should have_contents public_contents }
      it { should have_link grave.quarter.name }
      
      context "grave with associated people" do
        let!(:p1) { create(:person, grave: grave) }
        let!(:p2) { create(:person, grave: grave, first_name: 'Hilda') }
        before {visit grave_path(grave) }
        
        it "should list associated people" do
          expect(page).to have_links [p1.full_name, p2.full_name]
        end
      end
    end
    
    context "as admin" do
      before do
        sign_in
        visit grave_path(grave)
      end
      
      it "should be able to destroy grave" do
        expect { click_link t('helpers.links.destroy') }.to change(Grave, :count).by(-1)
      end
    end
  end
  
  describe "edit" do
    let(:grave) { create(:grave) }
    let!(:quarter) { create(:quarter) }
    before do
      sign_in
      visit edit_grave_path(grave)
    end
    
    describe "valid updating" do
      let(:updated_grave) { attributes_for(:updated_grave, quarter: quarter) }
      before do
        updated_grave.delete(:grave_type)
        updated_grave.each do |field, value|
          fill_in simple_label(field), with: value
        end
        select quarter.name, from: simple_label(:quarter)
        click_button "Aktualizuj grób"
      end
      
      it { should have_contents(updated_grave.values + [quarter.name]) }
      
      it "should update grave" do
        updated = grave.reload
        updated_grave.each do |field, value|
          expect(updated[field]).to eq(value)
        end
        expect(updated.quarter).to eq(quarter)
      end
    end
    
    specify "trying to set number which is already taken" do
      grave2 = create(:updated_grave, quarter: grave.quarter)
      fill_in simple_label(:number), with: grave2.number
      click_button "Aktualizuj grób"
      
      expect(page).to have_title "Edytuj grób"
      expect(page).to have_content "zostało już zajęte"
    end
    
    specify "setting no quarter" do
      select "", from: simple_label(:quarter)
      click_button "Aktualizuj grób"
      
      expect(page).to have_content t('graves.show.no_quarter')
      expect(grave.reload.quarter).to be_nil
    end
  end
  
  describe "new" do
    let(:grave) { attributes_for(:grave) }
    let!(:quarter) { create(:quarter) }
    before do
      sign_in
      visit new_grave_path
      grave.delete(:grave_type)
      grave.each do |field, value|
        fill_in simple_label(field), with: value
      end
      select quarter.name, from: simple_label(:quarter)
    end
    
    it "should create a new grave" do
      expect { click_button "Utwórz grób" }.to change(Grave, :count).by(1)
    end
    
    it "should render a grave page" do
      click_button "Utwórz grób"
      expect(page).to have_contents(grave.values + [quarter.name])
    end
  end
end
