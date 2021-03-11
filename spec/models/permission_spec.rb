require 'rails_helper'

RSpec.describe Permission, type: :model do
  let(:create_review_permission) { Permission.find_by(name: 'can_create_review') }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_and_belong_to_many(:users) }

  describe 'Scopes' do
    describe '.named' do
      before { create(:permission, :create_review) }
      it 'returns permission with the given name' do
        expect(Permission.named('can_create_review')).to include(create_review_permission)
      end
    end

    describe '.non_admin_permissions' do
      before { create_all_permissions }
      it 'includes only non admin permissions' do
        expect(Permission.non_admin_permissions).to include(create_review_permission)
        expect(Permission.non_admin_permissions.count).to eq(5)
      end
      it 'does not includes permission to delete rating' do
        expect(Permission.non_admin_permissions).to_not include(Permission.find_by(name: 'can_delete_rating'))
      end
    end
  end
end
