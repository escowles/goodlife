require 'rails_helper'

RSpec.describe ImportController, type: :controller do
  let(:csv_file) { fixture_file_upload("import.csv") }
  let(:json_file) { fixture_file_upload("import.json") }

  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    before do
      valid_user
      sign_in valid_user
    end

    describe "GET /import" do
      it "displays the form" do
        get :form
        expect(response).to be_successful
        expect(response).to render_template "form"
      end
    end

    describe "POST /import" do
      describe "csv" do
        let(:csv_params) { { format: "csv", file: csv_file } }
        it "imports the data" do
          expect { post :import, params: csv_params }.to change { Entry.count }.by(2)
        end
      end

      describe "json" do
        let(:json_params) { { format: "json", file: json_file } }
        let(:json_clear_params) { { format: "json", file: json_file, clear: 1 } }
        it "imports the data" do
          expect { post :import, params: json_params }.to change { Entry.count }.by(2)
        end
        it "clears and imports the data" do
          type = Type.create!(name: "foo")
          entry = Entry.create!(name: "bar", type_id: type.id)
          post :import, params: json_clear_params
          expect(Entry.count).to eq(2)
        end
      end

      describe "bogus format" do
        let(:bogus_params) { { format: "bogus", file: csv_file } }
        it "does not import the data" do
          expect { post :import, params: bogus_params }.not_to change { Entry.count }
        end
      end
    end
  end
end
