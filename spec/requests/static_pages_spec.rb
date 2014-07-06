require 'rails_helper'

RSpec.describe "StaticPages", :type => :request do
  subject { page }
  
  describe "menu" do
    before { visit root_path }
    
    it "should have navigation links" do
      within "body > .navbar" do
        should have_link "Cmentarz",        href: root_url
        should have_link "Pochowane osoby", href: people_path
        should have_link "Groby",           href: graves_path
        should have_link "Kwatery",         href: quarters_path
      end
    end
  end
  
  describe "main page" do
    before { visit root_path }
    
    it { should have_title page_title }
  end
end
