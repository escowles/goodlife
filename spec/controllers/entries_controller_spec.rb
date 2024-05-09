require 'rails_helper'

RSpec.describe EntriesController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:type) { Type.create!(name: "bar") }
    let(:existing_entry) { Entry.create!(name: "foo", type_id: type.id) }
    before do
      existing_entry
      valid_user
      sign_in valid_user
    end

    describe "GET /index" do
      it "lists the objects" do
        get :index
        expect(response).to be_successful
        expect(assigns(:entries)).to eq([existing_entry])
      end
    end

    describe "GET /entries/1" do
      it "displays an existing object" do
        get :show, params: { id: existing_entry.id }
        expect(response).to be_successful
        expect(assigns(:entry)).to eq(existing_entry)
      end
    end

    describe "GET /entries/new" do
      it "displays the form" do
        get :new
        expect(response).to be_successful
        expect(response).to render_template "new"
      end
    end

    describe "GET /entries/1/edit" do
      it "displays the form" do
        get :edit, params: { id: existing_entry.id }
        expect(response).to be_successful
        expect(response).to render_template "edit"
      end
    end

    describe "POST /entries/" do
      describe "with valid parameters" do
        let(:valid_params) { { entry: { name: "baz", type_id: type.id } } }
        it "creates a new entry" do
          expect { post :create, params: valid_params }.to change { Entry.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { entry: { asdf: "bar" } } }
        it "does not create a new entry" do
          expect { post :create, params: invalid_params }.not_to change { Entry.count }
        end
      end
    end

    describe "PUT /entries/1" do
      describe "with valid parameters" do
        let(:valid_params) { { id: existing_entry.id, entry: { name: "bar" } } }
        it "updates the entry" do
          put :update, params: valid_params
          existing_entry.reload
          expect(existing_entry.name).to eq("bar")
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { id: existing_entry.id, entry: { name: nil } } }
        it "does not update the entry" do
          put :update, params: invalid_params
          existing_entry.reload
          expect(existing_entry.name).to eq("foo")
        end
      end
    end

    describe "DELETE /entries/1" do
      it "deletes the entry" do
        expect { delete :destroy, params: { id: existing_entry.id } }.to change { Entry.count }.by(-1)
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
