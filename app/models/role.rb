# frozen_string_literal: true

class Role < ApplicationRecord
  validates :resource_type,
          inclusion: { in: Rolify.resource_types },
          allow_nil: true

  has_and_belongs_to_many :users, join_table: :users_roles

  belongs_to :resource,
             polymorphic: true,
             optional: true

  scopify
end
