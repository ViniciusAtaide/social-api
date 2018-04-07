require 'rails_helper'
require 'pry'

RSpec.describe 'users' do

  let(:user) { create :user }
  let(:token) do
    post authenticate_path, params: { 
      email: user.email, 
      password: 'password' 
    }
    json["auth_token"]
  end

  describe 'authenticate' do
    
    let(:u) { create :user }
    before { post authenticate_path, params: { 
        email: u.email,
        password: 'password'
      }
    }

    subject { response }
    it { is_expected.to have_http_status 200 }

  end

  describe 'GET /users' do

    subject { json }
  
    context 'when there are no users' do
      before { get users_path, headers: { authorization: token } }
      it { is_expected.to have(1).items }
    end
  
    context 'when there are users' do
      before do
        create_list :user, 9
        get users_path, headers: { authorization: token }
      end
  
      it { is_expected.not_to be_empty }
      it { is_expected.to have(10).items }
      it { is_expected.to include include 'name' }
    end
  end
  
  describe 'GET /users/:id' do
    let(:user) { create :user }
  
    before { get users_path(user), headers: { authorization: token } }
  
    subject { json }
  
    it { is_expected.not_to be_empty }
    it { is_expected.to have(1).item }
  
    describe 'The first item' do
      subject { json[0] }
      it { is_expected.to include('name' => user.name) }
    end
  end
  
  describe 'POST /users' do
    context 'when another user has the same email' do
      before do
        post users_path, params: {
          name: Faker::Name.unique.name,
          email: user.email
        }, headers: { 
          authorization: token 
        }
      end
  
      subject { response }
  
      it { is_expected.to have_http_status 422 }
  
      context 'the response JSON' do
        subject { json }
  
        it { is_expected.to include 'message' }
      end
    end
  
    context 'when email is available' do
      before do
        post users_path, params: {
          name: Faker::Name.unique.name,
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }, headers: { 
          authorization: token 
        }
      end
  
      subject { response }
      it { is_expected.to have_http_status 201 }
  
      describe 'the response JSON' do
        subject { json }
        it { is_expected.to include 'email' }
      end
    end
  end
  
  describe 'PATCH /users' do
    before do 
      patch user_path(user), params: {
        name: Faker::Name.unique.name
      }, headers: { 
        authorization: token 
      }
    end
  
    subject { response }
    it { is_expected.to have_http_status 204 }
  end
  
  describe 'DELETE /users' do
    before { 
      delete user_path(user), headers: { authorization: token }
    }
  
    subject { response }
  
    it { is_expected.to have_http_status :no_content }
  
    context "when searching for user" do
      before { get user_path(user), headers: { authorization: token } }
  
      it { is_expected.to have_http_status :not_found }
    end
  end
  
end
