require 'rails_helper'

RSpec.describe EntryPeopleController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:person) { Person.create!(name: "foo") }
    let(:type) { Type.create!(name: "bar") }
    let(:entry) { Entry.create!(name: "baz", type_id: type.id) }
    before do
      valid_user
      sign_in valid_user
    end

    describe "POST /entry_people/" do
      describe "with valid parameters" do
        let(:valid_params) { { entry_person: { entry_id: entry.id, person_id: person.id } } }
        it "creates a new person" do
          expect { post :create, params: valid_params }.to change { EntryPerson.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { entry_person: { entry_id: -1 } } }
        it "does not create a new person" do
          expect { post :create, params: invalid_params }.not_to change { EntryPerson.count }
        end
      end
    end

    describe "DELETE /entry_people/1" do
      let(:existing_entry_person) { EntryPerson.create!(entry_id: entry.id, person_id: person.id) }
      before do
        existing_entry_person
      end
      it "deletes the person" do
        expect { delete :destroy, params: { id: existing_entry_person.id } }.to change { EntryPerson.count }.by(-1)
      end
    end
  end

  context "as an anonymous user" do
    describe "POST /entry_people/" do
      let(:valid_params) { { entry_person: { name: "bar" } } }
      it "fails" do
        post :create, params: valid_params
        expect(response).not_to be_successful
      end
    end
  end
end
