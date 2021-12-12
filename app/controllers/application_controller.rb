class ApplicationController < ActionController::Base
	before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :exception

	protected
  def after_sign_in_path_for(users)
    parcels_path
  end

  def after_sign_out_path_for(staff_user)
    flash[:notice] = 'Welcome! You have successfully sign out.'
    user_session_path
  end

	def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role_id,  address_attributes: [:id,:address_line_one, :address_line_two,
                                                                       :city, :state, :country,
                                                                       :pincode, :mobile_number]])
  end
end
