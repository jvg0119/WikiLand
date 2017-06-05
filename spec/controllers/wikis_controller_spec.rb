require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:my_wiki) { create(:wiki) }
  let(:my_wiki2) { create(:wiki) }
  let(:my_user) { create(:user) }

  describe "GET #index" do
    before { get :index }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @wikis" do
      expect(assigns(:wikis)).to eq([my_wiki, my_wiki2])
    end
    it "renders the index template" do
      expect(response).to render_template :index
    end
  end # GET #index

  describe "GET #show" do
    before { get :show, params: { id: my_wiki.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns requested wiki to @wiki" do
      expect(assigns(:wiki)).to eq(my_wiki)
    end
    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end   # GET #show

  describe "GET #new" do
    before { get :new }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "instantiates a new wiki" do
      expect(assigns(:wiki)).to be_a_new(Wiki)
      expect(assigns(:wiki)).to_not be_nil
    end
    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end   # GET #new

  describe "GET #edit" do
    before { get :edit, params: { id: my_wiki.id } }
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns wiki to be updated to @wiki" do
      wiki_instance = assigns(:wiki)
      expect(assigns(:wiki)).to eq(my_wiki)
      expect(wiki_instance.id).to eq(my_wiki.id)
      expect(wiki_instance.title).to eq(my_wiki.title)
      expect(wiki_instance.body).to eq(my_wiki.body)
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
  end   # GET #edit

  describe "POST #create" do
    before { sign_in my_user } # sign_in method from devise for use in controller

    context "with valid wiki attributes" do
      it "saves the new wiki in the database" do
        expect{ post :create, params: { wiki: attributes_for(:wiki) }
        }.to change{ Wiki.count }.by(1)
      end
      it "increases the number of Wiki by 1" do # same as above
        expect{ post :create, params: { wiki: {title: "New wiki title", body: "new body title"} }
      }.to change(Wiki, :count).from(0).to(1)
      end
      it "redirects to the newly created @wiki" do
        post :create, params: { wiki: attributes_for(:wiki) }
        expect(response).to redirect_to Wiki.last
      end
    end   # with valid wiki attributes

    context "with invalid attributes" do
      it "does not save the new wiki" do
        expect{ post :create, params: { wiki: attributes_for(:wiki, title: "") }
      }.to_not change{Wiki.count}
      end
      it "does not increase the number of Wiki" do # same as above
        expect{ post :create, params: { wiki: attributes_for(:wiki, body: "") }
      }.to_not change{Wiki.count}
      end
      it "re-renders back to the new template" do
        post :create, params: { wiki: {title: "", body:"wiki body"}}
        expect(response).to render_template(:new)
      end
    end   # with invalid attributes
  end   # POST #create

  describe "PATCH #update" do
    #before { put :update, params: { id: my_wiki.id, wiki: attributes_for(:wiki) } }
  #  before { my_wiki }

    context "with valid attributes" do
      it "assigns wiki to be updated to @wiki" do
        put :update, params: { id: my_wiki, wiki: attributes_for(:wiki, title: "My new wiki title", body: "my new wiki body*")}
        updated_wiki = assigns(:wiki)
        expect(updated_wiki.title).to eq("My new wiki title")
        expect(updated_wiki.body).to eq("my new wiki body*")
      end
      it "changes @wiki's attributes" do # same as above
        my_wiki # this method will need a starting wiki content to change
        expect{ put :update, params: { id: my_wiki.id, wiki: attributes_for(:wiki, title: "New wiki title", body: "new wiki body") }
        }.to change{Wiki.last.title}.from("Wiki title").to("New wiki title")
      end
      it "redirects to the updated @wiki" do
        #put :update, params: { id: my_wiki.id, wiki: {title:"title", body:"body"} } # OK also
        put :update, params: { id: my_wiki.id, wiki: attributes_for(:wiki)}
        expect(response).to redirect_to(my_wiki)
      end
    end   # with valid attributes
    context "with invalid attributes" do
      before { put :update, params: { id: my_wiki.id, wiki: attributes_for(:wiki, title: "")} }
      it "does not assign wiki to @wiki" do
        expect(my_wiki.title).to eq("Wiki title")
      end
      it "re-renders back to the edit template" do
        expect(response).to render_template(:edit)
      end
    end   # with invalid attributes
  end    # PATCH #update

  describe "DELETE #destroy" do
    before { delete :destroy, params: {id: my_wiki} }

    it "removes the selected @wiki" do
      expect(Wiki.count).to eq(0)
      expect(Wiki.where({id: my_wiki.id}).size).to eq(0)
    end
    it "redirect to the wikis index page" do
      #delete :destroy, params: { id: my_wiki }
      expect(response).to redirect_to(:wikis)
    end
  end   # DELETE #destroy

end   # WikisController
