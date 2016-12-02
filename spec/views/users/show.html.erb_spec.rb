require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password'))
  end

  it "renders attributes in <p>" do
    render
  end
end
