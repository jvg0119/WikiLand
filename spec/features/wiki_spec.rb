require 'rails_helper'

describe "Wikis" do
  let(:my_user) { create(:user, name: "John") }
  let(:my_wiki) { create(:wiki, title:"Wiki Title 1", user: my_user) }
  let(:my_wiki2) { create(:wiki, title:"Wiki Title 2", user: my_user) }

  describe "viewing the list of wikis" do
    it "shows the wikis" do
      my_wiki
      visit(wikis_path)
      #expect(page).to have_content("Wiki Title 1")
      expect(page).to have_link("Wiki Title 1")
      #save_and_open_page
    end
  end   # viewing the list of wikis

  describe "viewing individual wikis" do
    it "shows all the individual wiki's details" do
      my_wiki
      visit(wikis_path)
      click_link("Wiki Title 1")
      expect(current_path).to eq(wiki_path(my_wiki))
      expect(page).to have_content("Wiki Title 1")
      expect(page).to have_content("this is the wiki body")
      #save_and_open_page
    end
  end   # viewing individual wikis

  describe "navigation" do

    it "allows navigation from listing to individual page" do
      my_wiki
      visit(wikis_path)

      click_link("Wiki Title 1")
      expect(current_path).to eq(wiki_path(my_wiki))
      expect(page).to have_content("Wiki Title 1")
    end
    it "allows navigation from individual to listing page" do
      my_wiki
      visit(wiki_path(my_wiki))

      click_link("All Wikis")
      expect(current_path).to eq(wikis_path)
      expect(page).to have_content("Wiki Title 1")
    end
  end   # navigation

  describe "creation" do
    it "saves the wiki and show the wiki's detail page" do
      #login_as(my_user, user: my_user)
      #login_as(my_user, user: :user)
      login_as(my_user, scope: :user) # I want to understand this login_as what is scope?
      visit(wikis_path)

      click_link("Create new wiki")
      expect(current_path).to eq(new_wiki_path)
      fill_in("Title", with: "New Title")
      fill_in("Body", with: "New body")

      click_button("Create Wiki")
      expect(current_path).to eq(wiki_path(Wiki.last))
      expect(page).to have_content("New Title")
      expect(page).to have_content("New body")
      expect(page).to have_content("Your wiki was saved successfully!")
      #save_and_open_page
    end
    it "does not save the wiki if wiki is invalid" do
      login_as(my_user, scope: :user)
      visit(wikis_path)

      click_link("Create new wiki")
      expect(current_path).to eq(new_wiki_path)
      fill_in("Title", with: "")
      fill_in("Body", with: "New body")

      click_button("Create Wiki")
      expect(current_path).to eq(wikis_path) # I want to understand why this is going to the wikis_path??
      expect(page).to have_content("Your wiki was not saved. Please try again.")
      #save_and_open_page
    end
  end   # creating

  describe "edit" do
    it "updates the wiki and shows the wiki's updated details" do
      login_as(my_user, scope: :user)
      visit(wiki_path(my_wiki)) # my_wiki alone does not work; no shortcut here

      click_link("Edit")
      expect(current_path).to eq(edit_wiki_path(my_wiki))
      find_field("Title").value
      expect(find_field("Title").value).to eq(my_wiki.title)
      fill_in("Title", with: "Update wiki title")
      fill_in("Body", with: "update wiki body")

      click_button("Update Wiki")
      expect(current_path).to eq(wiki_path(Wiki.last))
      expect(page).to have_content("Update wiki title")
      expect(page).to have_content("update wiki body")
      expect(page).to have_content("Your wiki was updated successfully!")
      #save_and_open_page
    end
    it "does not update the wiki if the wiki is invalid" do
      login_as(my_user, user: :user)
      visit(wiki_path(my_wiki))

      click_link("Edit")
      expect(current_path).to eq(edit_wiki_path(my_wiki))
      expect(find_field("Title").value).to eq(my_wiki.title)
      expect(find_field("Body").value).to eq(my_wiki.body)
      fill_in("Title", with: "")

      click_button("Update Wiki")
      expect(current_path).to eq(wiki_path(my_wiki)) # same as in create this path is show instead of edit page
      expect(page).to have_content("Your wiki was not updated. Please try again.")
      #save_and_open_page
    end
  end   # edit

  describe "delete" do
    it "removes the wiki and shows the wiki list without the deleted wiki" do
      login_as(my_user, user: my_user)
      my_wiki; my_wiki2
      visit(wiki_path(my_wiki))

      click_link("Delete")
      expect(current_path).to eq(wikis_path)
      expect(page).to_not have_content(my_wiki.title)
      expect(page).to have_content(my_wiki2.title)
      #save_and_open_page
    end

  end   # destroy

end   # Wikis



#
