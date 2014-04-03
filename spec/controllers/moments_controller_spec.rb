require 'spec_helper'

describe MomentsController do
  describe "moments/as_unity_json" do
    it "should not blow up" do
      get :for_unity, format: 'json'
      expect(response).to be_success
    end
  end
end
