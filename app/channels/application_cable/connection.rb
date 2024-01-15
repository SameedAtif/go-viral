module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      session_key = cookies.encrypted[Rails.application.config.session_options[:key]]
      warden_key = session_key['warden.user.user.key']
      return reject_unauthorized_connection unless warden_key
      verified_id = warden_key[0][0]
      verified_user = User.find_by(id: verified_id)
      return reject_unauthorized_connection unless verified_user
      verified_user
    end
  end
end
