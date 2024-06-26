require 'rails_helper'

RSpec.describe EntriesController, type: :controller do

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    let(:type) { Type.create!(name: "bar") }
    let(:existing_entry) { Entry.create!(name: "foo", type_id: type.id, keywords: "|foo|bar|") }
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

      describe "with multiple types of entries" do
        let(:type2) { Type.create!(name: "quux") }
        let(:existing_entry2) { Entry.create!(name: "bam", type_id: type2.id, keywords: "|aa|zz|") }
        let(:person) { Person.create!(name: "bambam") }
        before do
          existing_entry2
          EntryPerson.create(entry_id: existing_entry.id, person_id: person.id)
        end

        it "filters based on the person parameter" do
          get :index, params: { person: person.id }
          expect(response).to be_successful
          expect(assigns(:entries)).to eq([existing_entry])
        end
        it "filters based on the keyword parameter" do
          get :index, params: { keyword: "aa" }
          expect(response).to be_successful
          expect(assigns(:entries)).to eq([existing_entry2])
        end
        it "filters based on the type parameter" do
          get :index, params: { type: "quux" }
          expect(response).to be_successful
          expect(assigns(:entries)).to eq([existing_entry2])
        end
      end
    end

    describe "GET /keywords" do
      it "displays a list of keyword links" do
        get :keywords
        expect(response).to be_successful
        expect(assigns(:keywords)).to eq(["bar", "foo"])
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
        let(:valid_params) { { id: existing_entry.id, entry: { name: "bar", date: "2024-05-01", end_date: "2024-05-22" } } }
        it "updates the entry" do
          put :update, params: valid_params
          existing_entry.reload
          expect(existing_entry.name).to eq("bar")
          expect(existing_entry.date).to eq("2024-05-01")
          expect(existing_entry.end_date).to eq("2024-05-22")
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

    describe "POST /entries/1/add_keyword" do
      describe "with valid params" do
        it "adds the keyword" do
          post :add_keyword, params: { id: existing_entry.id, keyword: "baz" }
          existing_entry.reload
          expect(existing_entry.keywords_to_list).to include("baz")
        end
      end
      describe "with invalid params" do
        it "doesn't change the keywords" do
          post :add_keyword, params: { id: existing_entry.id, keyword: "foo" }
          expect(existing_entry.keywords).to eq(existing_entry.reload.keywords)
        end
      end
    end

    describe "POST /entries/1/remove_keyword" do
      describe "with valid params" do
        it "removes the keyword" do
          post :remove_keyword, params: { id: existing_entry.id, keyword: "foo" }
          existing_entry.reload
          expect(existing_entry.keywords_to_list).not_to include("foo")
        end
      end
      describe "with invalid params" do
        it "doesn't change the keywords" do
          post :remove_keyword, params: { id: existing_entry.id, keyword: "asdf" }
          expect(existing_entry.keywords).to eq(existing_entry.reload.keywords)
        end
      end
    end

    describe "when errors occurs" do
      before do
        entry = Entry.new(keywords: "|foo|")
        allow(Entry).to receive(:find).and_return(entry)
        allow(entry).to receive(:save).and_return(false)
      end
      it "doesn't change the keywords" do
        post :add_keyword, params: { id: existing_entry.id, keyword: "asdf" }
        expect(existing_entry.keywords).to eq(existing_entry.reload.keywords)
      end
      it "doesn't change the keywords" do
        post :remove_keyword, params: { id: existing_entry.id, keyword: "foo" }
        expect(existing_entry.keywords).to eq(existing_entry.reload.keywords)
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
