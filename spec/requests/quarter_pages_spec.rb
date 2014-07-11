require 'rails_helper'

RSpec.describe "Quarter Pages", :type => :request do
  subject { page }
  
  describe "index" do
    before { visit quarters_path }
    let(:title) { t 'quarters.index.title' }
    
    it_behaves_like "index page"
    
    it "should list quarters" do
      quarter = create(:quarter)
      visit quarters_path
      expect(page).to have_link(quarter.name, href: quarter_path(quarter))
    end
  end
  
  describe "show" do
    let(:grave) { create(:grave) }
    before { visit quarter_path(grave.quarter) }
    
    let(:path) { quarter_path(grave.quarter) }
    let(:admin_only) { [grave.quarter.short_name] }
    let(:admin_actions) { [t('helpers.links.edit'), t('helpers.links.destroy')] }
    
    it_behaves_like "with admin content"
    
    it { should have_title "#{t 'title'} | #{grave.quarter.name}" }
    it { should have_selector 'h1', text: grave.quarter.name }
    it { should have_link grave.number, href: grave_path(grave) }
  end
end
