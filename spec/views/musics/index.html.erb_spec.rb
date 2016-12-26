require 'rails_helper'

RSpec.describe "musics/index", type: :view do
  before(:each) do
    assign(:musics, [
      Music.create!(),
      Music.create!()
    ])
  end

  it "renders a list of musics" do
    render
  end
end
