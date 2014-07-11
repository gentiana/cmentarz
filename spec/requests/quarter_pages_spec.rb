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
end
