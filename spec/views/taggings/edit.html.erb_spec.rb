require 'rails_helper'

RSpec.describe "taggings/edit", type: :view do
  before(:each) do
    @tagging = assign(:tagging, Tagging.create!(
      :book => nil,
      :tag => nil
    ))
  end

  it "renders the edit tagging form" do
    render

    assert_select "form[action=?][method=?]", tagging_path(@tagging), "post" do

      assert_select "input#tagging_book_id[name=?]", "tagging[book_id]"

      assert_select "input#tagging_tag_id[name=?]", "tagging[tag_id]"
    end
  end
end
