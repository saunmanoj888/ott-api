require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should validate_presence_of(:body) }
  it do
    should validate_uniqueness_of(:video_id)
      .scoped_to(:user_id)
      .with_message('review already submitted')
  end

  it { should belong_to(:video) }
  it { should belong_to(:user) }
end
