require 'rails_helper'
require 'pry'

RSpec.describe 'GET /posts' do
  subject { json }
  before do
    create_list(:post, 5)
    get posts_path
  end

  it { is_expected.not_to be_empty }
  it { is_expected.to have(5).items }
end

RSpec.describe 'GET /posts/:id' do
  subject { json }

  before do
    post = create(:post)
    get post_path(post)
  end

  it { is_expected.to include 'content' }

end

RSpec.describe 'POST /posts' do
  subject { json }
  let(:content) { Faker::Lorem.paragraph }

  before do
    create(:user) do |u|
      post user_posts_path(u), params: { content: content }
    end
  end

  it { is_expected.to include 'content' => content }
  it { is_expected.to include 'likes' }

end

RSpec.describe 'PATCH /posts' do
  let(:post) { create(:post) }

  before do
    patch post_path(post), params: { content: Faker::Lorem.paragraph }
  end

  subject { response }
  it { is_expected.to have_http_status 204 }
end

RSpec.describe 'Self Like /user/:user_id/post/:post_id' do
  before do
    create(:user) do |u|
      p = u.posts.create attributes_for :post
      get user_post_like_path u, p
    end
  end

  subject { json }

  fit { is_expected.to include 'likes' }
end
