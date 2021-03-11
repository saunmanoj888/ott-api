class Permission < ApplicationRecord
  module List
    NON_ADMIN_APPLICABLE = %w[can_create_review can_edit_review can_delete_review can_create_rating
                              can_edit_rating].freeze
    ADMIN_APPLICABLE = (NON_ADMIN_APPLICABLE + ['can_delete_rating']).freeze
  end

  validates_presence_of :name
  validates_uniqueness_of :name

  has_and_belongs_to_many :users

  scope :named, ->(permission_name) { where('name = ?', permission_name) }
  scope :non_admin_permissions, -> { where(name: List::NON_ADMIN_APPLICABLE) }
end
