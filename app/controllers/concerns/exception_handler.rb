module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ error: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordNotUnique do |e|
      json_response({ error: e.message }, :bad_request)
    end

    rescue_from CanCan::AccessDenied do |e|
      json_response({ error: e.message }, :unauthorized)
    end
  end
end
