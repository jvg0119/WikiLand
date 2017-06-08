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

  describe "scopes" do
    before do
      @public_wiki = create(:wiki)
      @private_wiki = create(:wiki, private: true)
    end
    describe "public_wikis" do
      it "returns all public wikis" do
        expect(Wiki.public_wikis.count).to eq(1)
        expect(Wiki.public_wikis).to eq([@public_wiki])
        expect(Wiki.public_wikis).to_not eq([@private_wiki])
      end
    end
    describe "private_wikis" do
      it "returns all private wikis" do
        expect(Wiki.private_wikis.count).to eq(1)
        expect(Wiki.private_wikis).to eq([@private_wiki])
        expect(Wiki.private_wikis).to_not eq([@public_wiki])
      end
    end
  end   # scopes

end   # Wiki model
