require "rails_helper"

RSpec.describe KeywordMappingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/keyword_mappings").to route_to("keyword_mappings#index")
    end

    it "routes to #new" do
      expect(get: "/keyword_mappings/new").to route_to("keyword_mappings#new")
    end

    it "routes to #show" do
      expect(get: "/keyword_mappings/1").to route_to("keyword_mappings#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/keyword_mappings/1/edit").to route_to("keyword_mappings#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/keyword_mappings").to route_to("keyword_mappings#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/keyword_mappings/1").to route_to("keyword_mappings#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/keyword_mappings/1").to route_to("keyword_mappings#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/keyword_mappings/1").to route_to("keyword_mappings#destroy", id: "1")
    end
  end
end
