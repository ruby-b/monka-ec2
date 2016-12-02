require 'rails_helper'

RSpec.describe "taggings/new", type: :view do
  let(:book) { Book.first }
  let(:tag) { Tag.first }

  before(:each) do
    assign(:tagging, Tagging.new(
      :book => book,
      :tag => tag
                                 ))
    @book = assign(:book, book)
  end

  it "renders new tagging form" do
    render

    assert_select "form[action=?][method=?]", book_taggings_path(@book), "post" do

      assert_select "select#tagging_tag_id[name=?]", "tagging[tag_id]"
    end
  end
end
