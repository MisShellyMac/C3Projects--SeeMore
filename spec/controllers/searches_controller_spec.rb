require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  let (:invalid_search) { "" }
  let (:valid_search)   { "words" }

  before { session[:stalker_id] = 1 }

  describe "POST #search" do
    it "requires login" do
      session[:stalker_id] = nil
      post :search, search_twitter: valid_search

      expect(response).to redirect_to(landing_path)
    end

    context "searching for a Twitter user" do
      it "redirects you to home page when you don't enter a search term" do
        post :search, search: invalid_search, client: "twitter"
        expect(response).to redirect_to(root_path)
      end

      it "redirects you to the search show page when you enter a search term" do
        post :search, search: valid_search, client: "twitter"
        expect(response).to redirect_to(search_results_path("twitter", valid_search))
      end
    end

    context "searching for an Instagram user" do
      it "redirects you to home page when you don't enter a search term" do
        post :search, search: invalid_search, client: "instagram"
        expect(response).to redirect_to(root_path)
      end

      it "redirects you to the search show page when you enter a search term" do
        post :search, search: valid_search, client: "instagram"
        expect(response).to redirect_to(search_results_path("instagram", valid_search))
      end
    end
  end

  describe "GET #show" do
    it "requires login" do
      session[:stalker_id] = nil
      get :show, client: "twitter", search_term: "search"

      expect(response).to redirect_to(landing_path)
    end

    context "searching for a Twitter user" do
      before :each do
        VCR.use_cassette('search_twitter_users') do
          get :show, client: "twitter", search_term: "search"
        end
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end

    context "searching for an Instagram user" do
      before :each do
        VCR.use_cassette('search_instagram_users') do
          get :show, client: "instagram", search_term: "search"
        end
      end

      it "responds successfully with an HTTP 200 status code" do
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the show template" do
        expect(response).to render_template("show")
      end
    end
  end
end
