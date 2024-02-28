module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ::ActiveRecord::ReadOnlyRecord do |e|
      redirect_back fallback_location: root_path, flash: {error: e.message}
    end

    rescue_from ::ActiveRecord::RecordNotFound do |e|
      redirect_back fallback_location: root_path, flash: {error: e.message}
    end

    rescue_from ::ActiveRecord::RecordNotUnique do |e|
      redirect_back fallback_location: root_path, flash: {error: e.message}
    end

    rescue_from ::ActiveModel::ValidationError do |e|
      redirect_back fallback_location: root_path, flash: {error: e.message}
    end

    rescue_from ::ActiveRecord::RecordInvalid do |e|
      redirect_back fallback_location: root_path, flash: {error: e.message}
    end

    rescue_from ::Pundit::NotAuthorizedError do |e|
      policy_name = e.policy.class.to_s.underscore
      message = I18n.t "#{policy_name}.#{e.query}", scope: "pundit", default: :default

      redirect_back fallback_location: root_path, flash: {error: message}
    end
  end
end
