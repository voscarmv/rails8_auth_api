module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    after_action :refresh_session
    # helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def authenticated?
      resume_session
    end

    def require_authentication
      resume_session || render_unauthorized
    end

    # def resume_session
    #   Current.session ||= find_session_by_cookie
    # end

    # def find_session_by_cookie
    #   Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    # end

    def resume_session
      Current.session = find_session_by_token
    end
  
    def find_session_by_token
      Session.find_by(token: request.headers[:authorization]&.split(" ")[-1])
    end

    def refresh_session
      if Current.session
        Current.session.regenerate_token!
        response.set_header('Authorization', "Bearer #{Current.session.token}")
      end
    end
    def render_unauthorized
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end

    # def after_authentication_url
    #   session.delete(:return_to_after_authenticating) || root_url
    # end

    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
      end
    end

    def terminate_session
      Current.session.destroy
      # cookies.delete(:session_id)
    end
end
