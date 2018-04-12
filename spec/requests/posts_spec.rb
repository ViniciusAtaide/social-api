require 'rails_helper'

RSpec.describe 'Posts' do

  let(:user) { create :user }
  let(:token) do
    post authenticate_path, params: {
      email: user.email,
      password: 'password'
    }
    return json["auth_token"]
  end

  describe 'GET /posts' do
    subject { json }

    before do
      create_list(:post, 5)
      get posts_path, headers: { authorization: token }
    end

    it { is_expected.not_to be_empty }
    it { is_expected.to have(5).items }
    it { is_expected.to include include 'comments' =>  [] }
  end

  describe 'GET /posts/:id' do
    subject { json }

    let(:p) { create :post }

    before do
      get post_path(p), headers: { authorization: token }
    end

    it { is_expected.to include 'content' => p.content }

  end
  describe 'POST /posts' do
    subject { json }

    let(:content) { Faker::Lorem.paragraph }

    before do
      create(:user) do |u|
        post user_posts_path(u), params: { content: content },
                                 headers: { authorization: token}
      end
    end

    it { is_expected.to include 'content' => content }
  end

  describe 'PATCH /posts' do
    let(:p) do
      create :post do |p|
        p.user = user
        p.save!
      end
    end

    let(:content) { Faker::Lorem.paragraph }

    before do
      patch post_path(p), params: { content: content },
                          headers: { authorization: token }
    end

    describe 'The Response' do
      subject { response }
      it { is_expected.to have_http_status 204 }
    end

    describe 'The post' do
      before { get post_path(p), headers: { authorization: token } }

      subject { json }

      it { is_expected.to include 'content' => content }
    end

  end
  describe 'Like/Unlike /post/:id' do

    let(:u) { create :user }
    let(:u2) { create :user }
    let(:p) do
      create :post do |p|
        p.user = u
      end
    end

    subject { json }

    describe 'Like' do
      context 'Self like' do
        before do
          post post_like_path(p), params: { liked_from: u.id },
                                  headers: { authorization: token }
        end

        describe 'The response' do
          subject { response }
          it { is_expected.to have_http_status 200 }
        end

        describe 'The likes' do
          subject { json }

          it { is_expected.to have(1).items }
        end
      end

      context 'Liking other post' do
        before do
          post post_like_path(p), params: { liked_from: u2.id },
                                  headers: { authorization: token }
        end

        describe 'The response' do
          subject { response }
          it { is_expected.to have_http_status 200 }
        end

        describe 'The likes' do
          subject { json }

          it { is_expected.to have(1).items }
        end
      end
    end


    describe 'Unlike' do
      context 'Self unlike' do
        before do
          post post_unlike_path(p), params: { liked_from: u.id },
                                    headers: { authorization: token }
        end

        describe 'The response' do
          subject { response }

          it { is_expected.to have_http_status 200 }
        end

        describe 'The likes' do
          subject { json }

          it { is_expected.to be_empty }
        end
      end
      context 'Unliking other post' do
        before do
          post post_unlike_path(p), params: { liked_from: u2.id },
                                    headers: { authorization: token }
        end

        describe 'The response' do
          subject { response }

          it { is_expected.to have_http_status 200 }
        end

        describe 'The likes' do
          subject { json }

          it { is_expected.to be_empty }
        end
      end
    end
  end

  describe 'Likes /post/:id' do

    let(:u) { create :user }
    let(:u2) { create :user }
    let(:u3) { create :user }
    let(:p) {
      create :post do |p|
        p.user = u
      end
    }

    before do
      post post_like_path(p), params: { liked_from: u2.id },
                              headers: { authorization: token }
      post post_like_path(p), params: { liked_from: u3.id },
                              headers: { authorization: token }
      get post_likes_path(p), headers: { authorization: token }
    end

    subject { json }

    it { is_expected.to include u2.id }
  end
end
