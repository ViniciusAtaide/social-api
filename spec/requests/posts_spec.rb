require 'rails_helper'

RSpec.describe 'GET /posts' do
  subject { json }
  before do
    create_list(:post, 5)
    get posts_path
  end

  it { is_expected.not_to be_empty }
  it { is_expected.to have(5).items }
  #it { is_expected.to include include "user_id" => user.id }

end
RSpec.describe 'GET /posts/:id' do
  let(:post) { Post.first }
  before { get user_post_path(user, post) }

  #it { is_expected.to include "content" => post.content }
end
