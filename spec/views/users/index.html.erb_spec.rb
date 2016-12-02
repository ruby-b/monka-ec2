require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(email: 'user1@example.com', password: 'password', password_confirmation: 'password'),
      User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password')
    ])
  end

  it "renders a list of users" do
    render
  end
end
