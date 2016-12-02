require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:admin_user) { User.where(role: 'admin').first }
  before(:each) { sign_in admin_user }

  describe "GET /books" do
    it "works! (now write some real specs)" do
      get books_path
      expect(response).to have_http_status(200)
    end
  end
end
