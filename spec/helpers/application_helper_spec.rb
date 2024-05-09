require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  describe "#inline_button" do
    it "generates a button" do
      html = %{<form style="display:inline-block;" class="button_to" method="get" action="/path"><button type="submit">label</button></form>}
      expect(helper.inline_button("label", "/path")).to eq(html)
    end
  end
end
