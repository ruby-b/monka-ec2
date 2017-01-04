require 'rails_helper'

RSpec.describe "musics/edit", type: :view do
  before(:each) do
    @music = assign(:music, Music.create!())
  end

  it "renders the edit music form" do
    render

    assert_select "form[action=?][method=?]", music_path(@music), "post" do
    end
  end
end
