require "rails_helper"

RSpec.describe TaggingsController, type: :routing do
  describe "routing" do
    let(:book) { Book.first }
    let(:tagging) { book.taggings.first }

    it "routes to #new" do
      expect(:get => "/books/#{book.id}/taggings/new").to route_to("taggings#new", :book_id => "#{book.id}")
    end

    it "routes to #edit" do
      expect(:get => "/books/#{book.id}/taggings/#{tagging.id}/edit").to route_to("taggings#edit", :id => "#{tagging.id}", :book_id => "#{book.id}")
    end

    it "routes to #create" do
      expect(:post => "/books/#{book.id}/taggings").to route_to("taggings#create", :book_id => "#{book.id}")
    end

    it "routes to #update via PUT" do
      expect(:put => "/books/#{book.id}/taggings/#{tagging.id}").to route_to("taggings#update", :id => "#{tagging.id}", :book_id => "#{book.id}")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/books/#{book.id}/taggings/#{tagging.id}").to route_to("taggings#update", :id => "#{tagging.id}", :book_id => "#{book.id}")
    end

    it "routes to #destroy" do
      expect(:delete => "/books/#{book.id}/taggings/#{tagging.id}").to route_to("taggings#destroy", :id => "#{tagging.id}", :book_id => "#{book.id}")
    end

  end
end
