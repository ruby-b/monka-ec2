require 'rails_helper'

RSpec.describe "taggings/edit", type: :view do
  let(:book) { Book.first }
  let(:tag) { Tag.first }

  before(:each) do
    @tagging = assign(:tagging, Tagging.create!(
      :book => book,
      :tag => tag
    ))
    @book = assign(:book, book)
  end

  it "renders the edit tagging form" do
    render

    assert_select "form[action=?][method=?]", book_tagging_path(@book, @tagging), "post" do

      assert_select "select#tagging_tag_id[name=?]", "tagging[tag_id]"
    end
  end
end
