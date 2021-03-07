module RateableDelegate
  extend ActiveSupport::Concern

  included do
    delegate :full_name, to: :user
    alias added_by full_name
  end
end
