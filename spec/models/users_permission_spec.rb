require 'rails_helper'

RSpec.describe UsersPermission, type: :model do
  it { should validate_uniqueness_of(:permission_id).scoped_to(:user_id) }
  it { should belong_to(:permission) }
  it { should belong_to(:user) }
end
