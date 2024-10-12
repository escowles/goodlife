require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  context "as a valid user" do
    let(:valid_user) { User.create!(email: "user@example.org", password: "foobar") }
    before do
      valid_user
      sign_in valid_user
    end

    describe "GET /util" do
      it "displays the form" do
        get :util
        expect(response).to be_successful
        expect(response).to render_template "util"
      end
    end
  end
end
