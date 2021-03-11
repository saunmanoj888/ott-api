require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user, first_name: 'John', last_name: 'Doe') }
  let(:new_user) { build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:email) }

  it { should have_many(:ratings).dependent(:destroy) }
  it { should have_many(:reviews).dependent(:destroy) }
  it { should have_and_belong_to_many(:permissions) }

  describe 'Instance Methods' do
    describe '#full_name' do
      it 'returns full name of the User' do
        expect(user.full_name).to eq('John Doe')
      end
    end

    describe '#can_access?' do
      context 'When User has the applicable permission' do
        before { create(:permission, :create_review) }
        it 'returns true' do
          expect(user.can_access?('can_create_review')).to eq(true)
        end
      end

      context 'When User does not have the applicable permission' do
        it 'returns false' do
          expect(user.can_access?('can_delete_rating')).to eq(false)
        end
      end
    end
  end

  describe 'Callbacks' do
    describe '.set_default_non_admin_permissions' do
      context 'When User Sign up successfully' do
        before { create_all_permissions }
        it 'creates default non admin permissions for the User' do
          expect {
            new_user.save
          }.to change { new_user.permissions.count }.from(0).to(5)
        end
        it 'should not have permission to delete ratings by default' do
          expect(user.permissions).to_not include(Permission.named('can_delete_rating'))
        end
      end
    end
  end
end
