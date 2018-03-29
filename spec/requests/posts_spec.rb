require 'rails_helper'

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
    post = create :post
    get post_path(post)
  end

  it { is_expected.to include 'content' }

end

RSpec.describe 'POST /posts' do
  subject { json }

  let(:content) { Faker::Lorem.paragraph }

  before do
    create(:user) do |u|
      post user_posts_path u, params: { content: content }
    end
  end

  it { is_expected.to include 'content' => content }
end

RSpec.describe 'PATCH /posts' do
  let(:post) { create :post }
  let(:content) { Faker::Lorem.paragraph }

  before do
    patch post_path post, params: { content: content }
  end

  describe 'The Response' do
    subject { response }
    it { is_expected.to have_http_status 204 }
  end

  describe 'The post' do
    before { get post_path post }
    subject { json }

    it { is_expected.to include 'content' => content }
  end
end

RSpec.describe 'Like/Unlike /post/:id' do

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
        post post_like_path p, params: { liked_from: u.id }
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
        post post_like_path p, params: { liked_from: u2.id }
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
        post post_unlike_path(p), params: { liked_from: u.id }
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
        post post_unlike_path(p), params: { liked_from: u2.id }
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
