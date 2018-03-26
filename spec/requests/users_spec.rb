require 'rails_helper'

RSpec.describe 'GET /users' do
  subject { json }

  context 'when there are no users' do
    before { get users_path }
    it { is_expected.to be_empty }
  end

  context 'when there are users' do
    before do
      create_list :user, 10
      get users_path
    end

    it { is_expected.not_to be_empty }
    it { is_expected.to have(10).items }
    it { is_expected.to include include 'name' }
  end
end

RSpec.describe 'GET /users/:id' do
  let(:user) { create :user }

  before { get users_path(user) }

  subject { json }

  it { is_expected.not_to be_empty }
  it { is_expected.to have(1).item }

  context 'The first item' do
    subject { json[0] }
    it { is_expected.to include('name' => user.name) }
  end
end

RSpec.describe 'POST /users' do
  context 'when another user has the same email' do
    let(:user) { create :user }

    before do
      post users_path, params: {
        name: Faker::Name.unique.name,
        email: user.email
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
        email: Faker::Internet.email
      }
    end

    subject { response }
    it { is_expected.to have_http_status 201 }

    context 'the response JSON' do
      subject { json }
      it { is_expected.to include 'email' }
    end
  end
end

RSpec.describe 'PATCH /users' do
  let(:user) { create :user }

  before do
    patch user_path user, params: {
      name: Faker::Name.unique.name
    }
  end

  subject { response }
  it { is_expected.to have_http_status 204 }
end

RSpec.describe 'DELETE /users' do
  let(:user) { create :user }

  before { delete user_path user }

  subject { response }

  it { is_expected.to have_http_status :no_content }

  context "when searching for user" do
    before { get user_path user }

    it { is_expected.to have_http_status 404 }
  end
end
