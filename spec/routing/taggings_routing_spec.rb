require "rails_helper"

RSpec.describe TaggingsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/books/1/taggings/new").to route_to("taggings#new", :book_id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/books/1/taggings/1/edit").to route_to("taggings#edit", :id => "1", :book_id => "1")
    end

    it "routes to #create" do
      expect(:post => "/books/1/taggings").to route_to("taggings#create", :book_id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/books/1/taggings/1").to route_to("taggings#update", :id => "1", :book_id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/books/1/taggings/1").to route_to("taggings#update", :id => "1", :book_id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/books/1/taggings/1").to route_to("taggings#destroy", :id => "1", :book_id => "1")
    end

  end
end
