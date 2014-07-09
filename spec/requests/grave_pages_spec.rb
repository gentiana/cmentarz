require 'rails_helper'

RSpec.describe "Grave Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit graves_path }
    let(:title) { t 'graves.index.title' }
    
    it { should have_title page_title(title) }
    it { should have_selector 'h1', text: title }
    
    describe "content" do
      let!(:quarter) { create(:quarter, name: 'Kwatera 5') }
      
      it "shouldn't list quarter which has no graves" do
        expect(page).not_to have_link 'Kwatera 5'
      end
      
      it "should list quarter with its graves" do
        create(:grave, quarter: quarter, number: '555')
        visit graves_path
        expect(page).to have_link 'Kwatera 5'
        expect(page).to have_link '555'
      end
    end
  end
  
  describe "show" do
    let(:grave) { create(:grave) }
    let(:public_contents) { [grave.name, grave.number, grave.description] }
    let(:admin_only) { [grave.family_name, grave.notes] }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy')] }
    
    context "as plain user" do
      before { visit grave_path(grave) }
      
      it { should have_contents public_contents }
      it { should have_link grave.quarter.name }
      
      it { should_not have_contents admin_only }
      it { should_not have_links admin_actions }
      
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
      
      it { should have_contents admin_only }
      it { should have_links admin_actions }
    end
  end
end
