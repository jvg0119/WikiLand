require 'rails_helper'

RSpec.describe WikisController, type: :controller do
  let(:standard_user) { create(:user, name: "Standard user", role: "standard") }
   let(:premium_user) { create(:user, name: "Premium user", role: "premium") }
  # let(:admin_user) { create(:user, name: "Admin user", role: "admin") }
  # let(:other_user) { create(:user, name: "Other user", role: "premium") }

  let(:wiki1) { create(:wiki, title: "Wiki title 1", private: false, user: standard_user) }
  let(:wiki2) { create(:wiki, title: "Wiki title 2", private: false, user: standard_user) }
  let(:wiki3) { create(:wiki, title: "Wiki title 3", private: true, user: premium_user) } # coll
  let(:wiki4) { create(:wiki, title: "Wiki title 4", private: true, user: premium_user) }
  # let(:wiki5) { create(:wiki, title: "Wiki title 5", private: true, user: admin_user) }
  # let(:wiki6) { create(:wiki, title: "Wiki title 6", private: true, user: admin_user) }
  # let(:wiki7) { create(:wiki, title: "Wiki title 7", private: true, user: other_user) } # coll
  # let(:wiki8) { create(:wiki, title: "Wiki title 8", private: true, user: other_user) }
  #
   let(:collaborator1) { create(:collaborator, user: standard_user , wiki: wiki3 ) }
  # let(:collaborator2) { create(:collaborator, user: premium_user , wiki: wiki7 ) }

# =============================================
  describe "un-signed or guest user access" do
    describe "GET #index" do
      before { get :index }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "returns only public wikis" do
        expect(assigns(:wikis)).to eq([wiki1, wiki2])
        expect(assigns(:wikis)).to_not eq([wiki3])#, wiki4, wiki5, wiki6, wiki7, wiki8])
        expect(assigns(:wikis).count).to eq(2)
      end
    end   # GET #index

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: wiki1.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns requested public wiki to @wiki" do
        get :show, params: { id: wiki1.id }
        expect(assigns(:wiki)).to eq(wiki1)
        expect(assigns(:wiki)).to_not eq(wiki3)
      end
    end   # GET #show

    describe "GET #new" do
      before { get :new }
      it "requires login and redirects to login url" do
        get :new
        expect(response).to redirect_to new_user_session_url
      end
    end    # GET #new

    describe "GET #edit" do
      it "requires login and redirects to login url" do
        get :edit, params: { id: wiki1.id }
        expect(response).to redirect_to new_user_session_url
      end
    end   # GET #edit

    describe "POST #create" do
      it "requires login and redirects to login url" do
        post :create, params: { wiki: attributes_for(:wiki) }
        expect(response).to redirect_to new_user_session_url
      end
    end   # POST #create

    describe "PATCH #update" do
      it "requires login and redirects to login url" do
        put :update, params: { id: wiki1, wiki: attributes_for(:wiki, title: "My new wiki title", body: "my new wiki body*")}
        expect(response).to redirect_to new_user_session_url
      end
    end   # PATCH #update

    describe "PATCH #update" do
      it "requires login and redirects to login url" do
        delete :destroy, params: {id: wiki1.id }
        expect(response).to redirect_to new_user_session_url
      end
    end   # PATCH #update

  end   # un-signed or guest user access


# =============================================
  describe "signed-in standard user access" do
    before { sign_in(standard_user)}
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
      it "assigns public and the current user's private collaboration wikis to @wikis" do
        wiki1; wiki2 # public wikis
        collaborator1 # wiki3
        get :index
        expect(assigns(:wikis)).to eq([wiki1, wiki2, wiki3])
        expect(assigns(:wikis).count).to eq(3)
      end
      it "assigns public wikis to @public_wikis" do
        wiki1; wiki2; wiki4;
        collaborator1 # wiki3
        get :index
        expect(assigns(:public_wikis)).to eq([wiki1, wiki2])
        expect(assigns(:public_wikis)).to_not eq([wiki3, wiki4])
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end # GET #index

    describe "GET #show" do
      before { get :show, params: { id: wiki1.id } }
      it "returns http success" do
      #  get :show, params: { id: wiki1.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns requested wiki to @wiki" do
      #  get :show, params: { id: wiki1.id }
        expect(assigns(:wiki)).to eq(wiki1)
      end

# does not work   need third party pundit-matcher gem
# try this later
      # it "assigns to @wiki if the requested wiki is private and the user's collaboration wiki" do
      #   get :show, params: { id: wiki3.id }
      #   expect(assigns(:wiki)).to eq(wiki3)
      # end
      # it "does not assign to @wiki if requested wiki is private and not the user's collaboration wiki" do
      #   get :show, params: { id: wiki8 }
      #   expect(Wiki.count).to eq(0)
      # end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end   # GET #show

    describe "GET #new" do
      before { get :new }
      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
      it "instantiates a new public wiki" do
        expect(assigns(:wiki)).to be_a_new(Wiki)
        expect(assigns(:wiki)).to_not be_nil
      end
      it "renders the new template" do
        expect(response).to render_template(:new)
      end
    end   # GET #new

    describe "GET #edit" do
    #  before { get :edit, params: { id: wiki1.id } }
      it "returns http success" do
        get :edit, params: { id: wiki1.id }
        expect(response).to have_http_status(:success)
      end
      it "assigns wiki to be updated to @wiki" do
        get :edit, params: { id: wiki1.id }
        expect(assigns(:wiki)).to eq(wiki1)
        p assigns(:wiki)
      end
      it "renders the edit template" do
        get :edit, params: { id: wiki1.id }
        expect(response).to render_template(:edit)
      end
    end   # GET #edit

    describe "POST #create" do
  #    before { sign_in my_user } # sign_in method from devise for use in controller

      context "with valid wiki attributes" do
        it "saves the new wiki in the database" do
          expect{ post :create, params: { wiki: attributes_for(:wiki) }
          }.to change{ Wiki.count }.by(1)
        end
        it "increases the number of public Wiki by 1" do # same as above
          expect{ post :create, params: { wiki: {title: "New wiki title", body: "new body title"} }
        }.to change(Wiki, :count).from(0).to(1)
        end
        it "increases the number of private Wiki by 1" do # same as above
          expect{ post :create, params: { wiki: {title: "New wiki title", body: "new body title", private: true} }
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

      context "with valid attributes" do
        it "assigns wiki to be updated to @wiki" do  
          put :update, params: { id: wiki1.id, wiki: attributes_for(:wiki, title: "My new wiki title", body: "my new wiki body*")}
          expect(assigns(:wiki).title).to eq("My new wiki title")
          expect(assigns(:wiki).body).to eq("my new wiki body*")
        end
        it "changes @wiki's attributes" do # same as above
          wiki1 # this method will need a starting wiki content to change
          expect{ put :update, params: { id: wiki1.id, wiki: attributes_for(:wiki, title: "New wiki title", body: "new wiki body") }
        }.to change{Wiki.last.title}.from("Wiki title 1").to("New wiki title")
        end
        it "redirects to the updated @wiki" do
          #put :update, params: { id: my_wiki.id, wiki: {title:"title", body:"body"} } # OK also
          put :update, params: { id: wiki1.id, wiki: attributes_for(:wiki)}
          expect(response).to redirect_to(wiki1)
        end
      end   # with valid attributes
      context "with invalid attributes" do
        before { put :update, params: { id: wiki1.id, wiki: attributes_for(:wiki, title: "")} }
        it "does not assign wiki to @wiki" do
          expect(wiki1.title).to eq("Wiki title 1")
        end
        it "re-renders back to the edit template" do
          expect(response).to render_template(:edit)
        end
      end   # with invalid attributes
    end    # PATCH #update

    describe "DELETE #destroy" do
      before { delete :destroy, params: {id: wiki1.id} }

      it "removes the selected @wiki" do
        expect(Wiki.count).to eq(0)
        expect(Wiki.where({id: wiki1.id}).size).to eq(0)
      end
      it "redirect to the wikis index page" do
      #  expect(response).to redirect_to(:wikis) # OK
        expect(response).to redirect_to(wikis_path)
      end
    end   # DELETE #destroy

  end   # signed in standard user access



end   # WikisController
