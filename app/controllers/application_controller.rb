class ApplicationController < ActionController::Base
    before_action :configure_devise, if: :devise_controller?

    private

    def configure_devise
        devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :dog_name, :username, images: [] ])
    end

end