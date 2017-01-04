require 'rails_helper'

RSpec.describe "musics/show", type: :view do
  before(:each) do
    @music = assign(:music, Music.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
