require "rails_helper"

RSpec.describe TaggingsController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/taggings/new").to route_to("taggings#new")
    end

    it "routes to #edit" do
      expect(:get => "/taggings/1/edit").to route_to("taggings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/taggings").to route_to("taggings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/taggings/1").to route_to("taggings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/taggings/1").to route_to("taggings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/taggings/1").to route_to("taggings#destroy", :id => "1")
    end

  end
end
