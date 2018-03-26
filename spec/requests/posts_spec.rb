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
end

RSpec.describe 'PATCH /posts' do
  let(:post) { create(:post) }

  before do
    patch post_path(post), params: { content: Faker::Lorem.paragraph }
  end

  subject { response }
  it { is_expected.to have_http_status 204 }
end

RSpec.describe 'Like /post/:id' do
  let(:u) { create(:user) }
  let(:u2) { create(:user) }

  context 'Self like' do
    before do
      p = build(:post)
      p.user = u
      p.save!
      post post_like_path(p), params: { liked_from: u.id }
    end
    subject { json }

    it { is_expected.to have(1).items }
    it { is_expected.to include include 'name' }
  end
  context 'Liking other post' do

    before do
      p = build(:post)
      p.user = u
      p.save!
      post post_like_path(p), params: { liked_from: u2.id }
    end

    subject { json }

    it { is_expected.to have(1).items }
    it { is_expected.to include include 'id' => u2.id }
  end
end

RSpec.describe 'Unlike /post/:id' do
  let(:u) { create(:user) }
  let(:u2) { create(:user) }

  context 'Self unlike' do
    before do
      p = build(:post)
      p.user = u
      p.save!
      post post_unlike_path(p), params: { liked_from: u.id }
    end
    subject { json }

    it { is_expected.to be_empty }
    it { is_expected.not_to include include 'name' }
  end

  context 'Unliking other post' do
    before do
      p = build(:post)
      p.user = u
      p.save!
      post post_like_path(p), params: { liked_from: u2.id }
    end

    subject { json }

    it { is_expected.to have(1).items }
    it { is_expected.to include include 'id' => u2.id }
  end
end
