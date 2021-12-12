class Parcel < ApplicationRecord

	STATUS = ['Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']

	validates :weight, :status, presence: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE
	validates :cost, presence:  true, numericality: true

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'
	has_many :parcel_record_histories 

	after_create :send_notification
	before_create :set_unique_no
	after_update :status_update_notification

	private

	def send_notification
		UserMailer.with(parcel: self).status_email.deliver_later
	end

	def set_unique_no
		self.unique_no = rand.to_s[2..6] 
	end

	def status_update_notification	
		UserMailer.with(parcel: self).status_update_email.deliver_later if self.saved_change_to_status?
	end
end
