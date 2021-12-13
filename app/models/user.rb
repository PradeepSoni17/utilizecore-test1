class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
	validates :name, :email,  presence: true
	validates :email, :uniqueness => true

	has_one :address , :dependent => :destroy
	has_many :send_parcels, foreign_key: :sender_id, class_name: 'Parcel'
	has_many :received_parcels, foreign_key: :receiver_id, class_name: 'Parcel'
	belongs_to :role

	accepts_nested_attributes_for :address
	after_initialize :set_default_role
	accepts_nested_attributes_for :address


	def name_with_address
		@name_with_address ||= [name, address.address_line_one, address.city, address.state, address.country, address.pincode, address.mobile_number].join('-')
	end
	
	def admin?
		role.name == 'Admin'
  end

  def user_registration_notification
  	UserMailer.with(user: self, password: self.password).registration_mail.deliver_later if self.email.present?
	end
	protected

	def set_default_role
		self.role_id = Role.where("name IN (?) ",  ['User','user']).first.id if role_id.nil?
  end


end
