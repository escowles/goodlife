require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { User.create!(email: "user@example.org", password: "foobar") }

  before do
    user
  end

  it "has properties" do
    expect(user.email).to eq("user@example.org")
    expect(user.password).to eq("foobar")
  end
end
