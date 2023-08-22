require 'rails_helper'
require 'spec_helper'

RSpec.describe Users::RegistrationsController do
  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end
  describe "POST create" do
    # it "should sanitize request body" do
    #   params = {
    #     sign_up: {
    #         first_name: 'John',
    #         last_name: 'Doe',
    #         email: 'johndoe@example.com',
    #         password: 'password',
    #         password_confirmation: 'password'
    #       }
    #     }
    #   should permit(:first_name, :last_name, :email, :password, :password_confirmation).
    #     for(:create, params: params).
    #     on(:sign_up)
    # end

    it "should not permit user_roles" do
      params = {
        sign_up: {
            first_name: 'John',
            last_name: 'Doe',
            email: 'johndoe@example.com',
            password: 'password',
            password_confirmation: 'password',
            user_roles: 'admin'
          }
        }
      should_not permit(:user_roles).
        for(:create, params: params).
        on(:sign_up)
    end
  end
end
