require 'rails_helper'

RSpec.describe EntryTagsController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:tag) { Tag.create!(name: "foo") }
    let(:type) { Type.create!(name: "bar") }
    let(:entry) { Entry.create!(name: "baz", type_id: type.id) }
    before do
      valid_user
      sign_in valid_user
    end

    describe "POST /entry_tags/" do
      describe "with valid parameters" do
        let(:valid_params) { { entry_tag: { entry_id: entry.id, tag_id: tag.id } } }
        it "creates a new tag" do
          expect { post :create, params: valid_params }.to change { EntryTag.count }.by(1)
        end
      end
      describe "with invalid parameters" do
        let(:invalid_params) { { entry_tag: { entry_id: -1 } } }
        it "does not create a new tag" do
          expect { post :create, params: invalid_params }.not_to change { EntryTag.count }
        end
      end
    end

    describe "DELETE /entry_tags/1" do
      let(:existing_entry_tag) { EntryTag.create!(entry_id: entry.id, tag_id: tag.id) }
      before do
        existing_entry_tag
      end
      it "deletes the tag" do
        expect { delete :destroy, params: { id: existing_entry_tag.id } }.to change { EntryTag.count }.by(-1)
      end
    end
  end

  context "as an anonymous user" do
    describe "POST /entry_tags/" do
      let(:valid_params) { { tag: { name: "bar" } } }
      it "fails" do
        post :create, params: valid_params
        expect(response).not_to be_successful
      end
    end
  end
end
