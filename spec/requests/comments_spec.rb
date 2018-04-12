require 'rails_helper'

RSpec.describe 'Comments' do

  let(:user) { create :user }
  let(:token) do
    post authenticate_path, params: {
      email: user.email,
      password: 'password'
    }
    return json["auth_token"]
  end

  describe 'GET /comments' do
    subject { json }
    before do
      create_list :comment, 5
      get comments_path, headers: { authorization: token }
    end

    it { is_expected.not_to be_empty }
    it { is_expected.to have(5).items }

  end

  describe 'GET /comment/:id' do
    subject { json }

    let(:comment) { create :comment }
    before do
      get comment_path(comment), headers: { authorization: token }
    end

    it { is_expected.to include 'content' => comment.content }
  end

  describe 'POST /comments' do

    let(:content) { Faker::Lorem.paragraph }
    let(:u) { create :user }
    let(:p) {
      create :post do |p|
        p.user = u
      end
    }

    subject { json }

    before do
      post user_post_comments_path(u, p), params: { content: content },
                                          headers: { authorization: token }
    end

    it { is_expected.to include 'content' => content }
    it { is_expected.to include 'post_id' => p.id }
    it { is_expected.to include 'user_id' => u.id }

  end

  describe 'PATCH /users/:user_id/posts/:post_id/comments' do
    let(:comment) { create :comment }
    let(:content) { Faker::Lorem.paragraph }

    before do
      patch comment_path(comment), params: { content: content },
                                  headers: { authorization: token }
    end

    describe 'The response' do
      subject { response }
      it { is_expected.to have_http_status 204 }
    end

    describe 'The comment' do
      before { get comment_path(comment), headers: { authorization: token } }
      subject { json }

      it { is_expected.to include 'content' => content }
    end
  end

  describe 'Like/Unlike /comment/:id' do

    let(:u) { create :user }
    let(:u2) { create :user }
    let(:p) do
      create :post do |p|
        p.user = u
      end
    end
    let(:c) do
      create :comment do |c|
        c.post = p
        c.user = u
      end
    end

    subject { json }

    describe '.like' do
      context 'self' do
        before do
          post comment_like_path(c), params: { liked_from: u.id },
                                     headers: { authorization: token }
        end

        it { is_expected.to have(1).items }
        it { is_expected.to include include 'name' }
      end

      context 'other comment' do
        before do
          post comment_like_path(c), params: { liked_from: u2.id },
                                    headers: { authorization: token }
        end

        it { is_expected.to have(1).items }
        it { is_expected.to include include 'id' => u2.id }
      end
    end

    describe '.unlike' do
      context 'self' do
        before do
          post comment_like_path(c), params: { liked_from: u.id },
                                    headers: { authorization: token }
          post comment_unlike_path(c), params: { liked_from: u.id },
                                    headers: { authorization: token }
        end

        it { is_expected.to be_empty }
      end
      context 'other post' do
        before do
          post comment_like_path(c), params: { liked_from: u2.id },
                                    headers: { authorization: token }
          post comment_unlike_path(c), params: { liked_from: u2.id },
                                      headers: { authorization: token }
        end

        it { is_expected.to be_empty }
      end
    end
  end
end
