require 'rails_helper'

RSpec.describe 'GET /comments' do
  subject { json }
  before do
    create_list(:comment, 5)
    get comments_path
  end

  it { is_expected.not_to be_empty }
  it { is_expected.to have(5).items }

end

RSpec.describe 'GET /comment/:id' do
  subject { json }

  before do
    comment = create(:comment)
    get comment_path(comment)
  end

  it { is_expected.to include 'content' }

end

RSpec.describe 'POST /comments' do
  subject { json }
  let(:content) { Faker::Lorem.paragraph }
  let(:u) { create(:user) }
  let(:p) { build(:post) }

  before do
    p.user = u
    p.save!
    post user_post_comments_path(u, p), params: { content: content }
  end

  it { is_expected.to include 'content' => content }
  it { is_expected.to include 'post_id' => p.id }
  it { is_expected.to include 'user_id' => u.id }

end
