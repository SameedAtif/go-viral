require 'rails_helper'
require 'spec_helper'

RSpec.describe Users::SessionsController do
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe "PUT switch_sessions" do
    let(:user) do
      user = create :user, :client, :creator
      create(:influencer, user: user)
      create(:client, user: user)
      user
    end

    context "when session_type is set to 1" do
      it "updates session variable to client" do
        sign_in user
        put 'switch_session', params: { type: 1 }
        expect(session[:user_role]).to include('Influencer')
      end
    end

    context "when session_type is set to 2" do
      it "updates session variable to influencer" do
        sign_in user
        put 'switch_session', params: { type: 2 }
        expect(session[:user_role]).to include('Client')
      end
    end

    context "when session_type is set to invalid number" do
      it "updates session variable to client" do
        sign_in user
        put 'switch_session', params: { type: 3 }
        expect(session[:user_role]).to include('Client')
      end
    end
  end
end
