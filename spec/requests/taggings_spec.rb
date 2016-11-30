require 'rails_helper'

RSpec.describe "Taggings", type: :request do
  describe "GET /taggings" do
    it "works! (now write some real specs)" do
      get taggings_path
      expect(response).to have_http_status(200)
    end
  end
end
