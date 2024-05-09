require 'rails_helper'

RSpec.describe TypesController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:existing_type) { Type.create!(name: "foo") }
    before do
      existing_type
      valid_user
      sign_in valid_user
    end

    describe "GET /index" do
      it "lists the objects" do
        get :index
        expect(response).to be_successful
        expect(assigns(:types)).to eq([existing_type])
      end
    end

    describe "GET /types/1" do
      it "displays an existing object" do
        get :show, params: { id: existing_type.id }
        expect(response).to be_successful
        expect(assigns(:type)).to eq(existing_type)
      end
    end

    describe "GET /types/new" do
      it "displays the form" do
        get :new
        expect(response).to be_successful
        expect(response).to render_template "new"
      end
    end

    describe "GET /types/1/edit" do
      it "displays the form" do
        get :edit, params: { id: existing_type.id }
        expect(response).to be_successful
        expect(response).to render_template "edit"
      end
    end

    describe "POST /types/" do
      describe "with valid parameters" do
        let(:valid_params) { { type: { name: "bar" } } }
        it "creates a new type" do
          expect { post :create, params: valid_params }.to change { Type.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { type: { asdf: "bar" } } }
        it "does not create a new type" do
          expect { post :create, params: invalid_params }.not_to change { Type.count }
        end
      end
    end

    describe "PUT /types/1" do
      describe "with valid parameters" do
        let(:valid_params) { { id: existing_type.id, type: { name: "bar" } } }
        it "updates the type" do
          put :update, params: valid_params
          existing_type.reload
          expect(existing_type.name).to eq("bar")
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { id: existing_type.id, type: { name: nil } } }
        it "does not update the type" do
          put :update, params: invalid_params
          existing_type.reload
          expect(existing_type.name).to eq("foo")
        end
      end
    end

    describe "DELETE /types/1" do
      it "deletes the type" do
        expect { delete :destroy, params: { id: existing_type.id } }.to change { Type.count }.by(-1)
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
