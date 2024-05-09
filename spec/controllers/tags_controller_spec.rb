require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:existing_tag) { Tag.create!(name: "foo") }
    before do
      existing_tag
      valid_user
      sign_in valid_user
    end

    describe "GET /index" do
      it "lists the objects" do
        get :index
        expect(response).to be_successful
        expect(assigns(:tags)).to eq([existing_tag])
      end
    end

    describe "GET /tags/1" do
      it "displays an existing object" do
        get :show, params: { id: existing_tag.id }
        expect(response).to be_successful
        expect(assigns(:tag)).to eq(existing_tag)
      end
    end

    describe "GET /tags/new" do
      it "displays the form" do
        get :new
        expect(response).to be_successful
        expect(response).to render_template "new"
      end
    end

    describe "GET /tags/1/edit" do
      it "displays the form" do
        get :edit, params: { id: existing_tag.id }
        expect(response).to be_successful
        expect(response).to render_template "edit"
      end
    end

    describe "POST /tags/" do
      describe "with valid parameters" do
        let(:valid_params) { { tag: { name: "bar" } } }
        it "creates a new tag" do
          expect { post :create, params: valid_params }.to change { Tag.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { tag: { asdf: "bar" } } }
        it "does not create a new tag" do
          expect { post :create, params: invalid_params }.not_to change { Tag.count }
        end
      end
    end

    describe "PUT /tags/1" do
      describe "with valid parameters" do
        let(:valid_params) { { id: existing_tag.id, tag: { name: "bar" } } }
        it "updates the tag" do
          put :update, params: valid_params
          existing_tag.reload
          expect(existing_tag.name).to eq("bar")
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { id: existing_tag.id, tag: { name: nil } } }
        it "does not update the tag" do
          put :update, params: invalid_params
          existing_tag.reload
          expect(existing_tag.name).to eq("foo")
        end
      end
    end

    describe "DELETE /tags/1" do
      it "deletes the tag" do
        expect { delete :destroy, params: { id: existing_tag.id } }.to change { Tag.count }.by(-1)
      end
    end
  end

  context "as an anonymous user" do
    describe "GET /index" do
      it "fails" do
        get :index
        expect(response).not_to be_successful
      end
    end
  end
end
