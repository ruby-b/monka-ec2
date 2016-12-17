require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TaggingsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Tagging. As you add validations to Tagging, be sure to
  # adjust the attributes here as well.
  let(:book) { Book.first }
  let(:tag) { Tag.first }

  let(:valid_attributes) {
    { book_id: book.id, tag_id: tag.id }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TaggingsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  let(:admin_user) { User.where(role: 'admin').first }
  before(:each) { sign_in admin_user }

  describe "GET #new" do
    it "assigns a new tagging as @tagging" do
      get :new, params: { book_id: book.id }, session: valid_session
      expect(assigns(:tagging)).to be_a_new(Tagging)
    end
  end

  describe "GET #edit" do
    it "assigns the requested tagging as @tagging" do
      tagging = Tagging.create! valid_attributes
      get :edit, params: {id: tagging.to_param, book_id: book.id }, session: valid_session
      expect(assigns(:tagging)).to eq(tagging)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Tagging" do
        expect {
          post :create, params: {tagging: valid_attributes, book_id: book.id}, session: valid_session
        }.to change(Tagging, :count).by(1)
      end

      it "assigns a newly created tagging as @tagging" do
        post :create, params: {tagging: valid_attributes, book_id: book.id}, session: valid_session
        expect(assigns(:tagging)).to be_a(Tagging)
        expect(assigns(:tagging)).to be_persisted
      end

      it "redirects to the created tagging" do
        post :create, params: {tagging: valid_attributes, book_id: book.id}, session: valid_session
        expect(response).to redirect_to(book_path(book))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_tag) { Tag.create(name: '音楽') }
      let(:new_attributes) {
        { tag_id: new_tag.id }
      }

      it "updates the requested tagging" do
        tagging = Tagging.create! valid_attributes
        put :update, params: {id: tagging.to_param, tagging: new_attributes, book_id: book.id}, session: valid_session
        tagging.reload
        expect(tagging.tag_id).to eq new_attributes[:tag_id]
      end

      it "assigns the requested tagging as @tagging" do
        tagging = Tagging.create! valid_attributes
        put :update, params: {id: tagging.to_param, tagging: valid_attributes, book_id: book.id}, session: valid_session
        expect(assigns(:tagging)).to eq(tagging)
      end

      it "redirects to the tagging" do
        tagging = Tagging.create! valid_attributes
        put :update, params: {id: tagging.to_param, tagging: valid_attributes, book_id: book.id}, session: valid_session
        expect(response).to redirect_to(book_path(book))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested tagging" do
      tagging = Tagging.create! valid_attributes
      expect {
        delete :destroy, params: {id: tagging.to_param, book_id: book.id}, session: valid_session
      }.to change(Tagging, :count).by(-1)
    end

    it "redirects to the taggings list" do
      tagging = Tagging.create! valid_attributes
      delete :destroy, params: {id: tagging.to_param, book_id: book.id}, session: valid_session
      expect(response).to redirect_to(book_url(book))
    end
  end

end
