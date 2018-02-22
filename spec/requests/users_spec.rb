require 'rails_helper'

RSpec.describe "Users" do
  describe "GET /users" do
    subject { json }
    context "when there are no users" do
      before { get users_path }
      it { is_expected.to be_empty }
    end

    context "when there are users" do
      before {
        create_list(:user, 10)
        get users_path
      }

      it { is_expected.not_to be_empty }
      it { is_expected.to include(include("name"))  }
      it { is_expected.to have(10).items }

    end
  end

  describe "GET /users/:id" do
    let(:user) { create(:user) }

    before { get users_path(user) }

    subject { json }

    it { is_expected.not_to be_empty }
    it { is_expected.to have(1).item }

  end
end
