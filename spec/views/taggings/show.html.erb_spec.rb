require 'rails_helper'

RSpec.describe "taggings/show", type: :view do
  before(:each) do
    @tagging = assign(:tagging, Tagging.create!(
      :book => nil,
      :tag => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
