require 'rails_helper'

RSpec.describe PeopleController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:existing_person) { Person.create!(name: "foo") }
    before do
      existing_person
      valid_user
      sign_in valid_user
    end

    describe "GET /index" do
      it "lists the objects" do
        get :index
        expect(response).to be_successful
        expect(assigns(:people)).to eq([existing_person])
      end
    end

    describe "GET /people/1" do
      it "displays an existing object" do
        get :show, params: { id: existing_person.id }
        expect(response).to be_successful
        expect(assigns(:person)).to eq(existing_person)
      end
    end

    describe "GET /people/new" do
      it "displays the form" do
        get :new
        expect(response).to be_successful
        expect(response).to render_template "new"
      end
    end

    describe "GET /people/1/edit" do
      it "displays the form" do
        get :edit, params: { id: existing_person.id }
        expect(response).to be_successful
        expect(response).to render_template "edit"
      end
    end

    describe "POST /people/" do
      describe "with valid parameters" do
        let(:valid_params) { { person: { name: "bar" } } }
        it "creates a new person" do
          expect { post :create, params: valid_params }.to change { Person.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { person: { asdf: "bar" } } }
        it "does not create a new person" do
          expect { post :create, params: invalid_params }.not_to change { Person.count }
        end
      end
    end

    describe "PUT /people/1" do
      describe "with valid parameters" do
        let(:valid_params) { { id: existing_person.id, person: { name: "bar" } } }
        it "updates the person" do
          put :update, params: valid_params
          existing_person.reload
          expect(existing_person.name).to eq("bar")
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { id: existing_person.id, person: { name: nil } } }
        it "does not update the person" do
          put :update, params: invalid_params
          existing_person.reload
          expect(existing_person.name).to eq("foo")
        end
      end
    end

    describe "DELETE /people/1" do
      it "deletes the person" do
        expect { delete :destroy, params: { id: existing_person.id } }.to change { Person.count }.by(-1)
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
