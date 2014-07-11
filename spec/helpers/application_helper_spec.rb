require "rails_helper"

describe ApplicationHelper do
  describe "#page_title" do
    it "returns the default title when called without args" do
      expect(helper.page_title).to eq(t('title'))
    end
    
    it "appends given subtitle to the base title" do
      expect(helper.page_title("Groby")).to eq("#{t('title')} | Groby")
    end
  end
  
  describe "#create_notice" do
    it "returns the right string" do
      expect(create_notice(:grave)).to eq("Utworzono grób")
    end
  end
  
  describe "#update_notice" do
    it "returns the right string" do
      expect(update_notice(:grave)).to eq("Aktualizowano grób")
    end
  end
  
  describe "#destroy_notice" do
    it "returns the right string" do
      expect(destroy_notice(:grave)).to eq("Usunięto grób")
    end
  end
end
