require 'rails_helper'

RSpec.describe "musics/new", type: :view do
  before(:each) do
    assign(:music, Music.new())
  end

  it "renders new music form" do
    render

    assert_select "form[action=?][method=?]", musics_path, "post" do
    end
  end
end
