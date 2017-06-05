require 'rails_helper'

RSpec.describe Wiki, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  let(:wiki) { create(:wiki, title: "New wiki title", body: "new wiki body") }
  describe "attributes" do
    it "has title and body attributes" do
      expect(wiki).to have_attributes(title: "New wiki title", body: "new wiki body")
    end
  end

  it "is invalid without a title" do
    wiki.title = ""
    expect(wiki).to be_invalid
  end

  it "is invalid without a body" do
    wiki.body = ""
    wiki.valid?
    expect(wiki.errors[:body]).to eq(["can't be blank"])
  end

  it "defaults as a public wiki" do
    expect(wiki.private).to eq(false)
  end
end   # Wiki model
