require 'rails_helper'

RSpec.describe DeathDate, :type => :model do
  context "it's probably useless to run it twice now", slow: true do
    it_behaves_like "date"
  end
end
