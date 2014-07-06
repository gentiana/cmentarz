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
end
