# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

['Speed Post', 'Regular'].each do |name|
	ServiceType.create(name: name)
end


['sender', 'receiver'].each do |name|
	user = User.new(name: name, email: "#{name}@gmail.com")
	user.build_address(address_line_one: "Test Street #{name}", city: "New Delhi",
		               state: "New Delhi", country: "India", pincode: 110111,
		               mobile_number: '9999999999')
	user.save


r1 = Role.create({ name: 'Admin'})
r2 = Role.create({ name: 'User'})

user = User.find(1)
user.update_attribute(role_id: ,'1')
user.update_attribute(password:, "123456")

user = User.find(2)
user.update_attribute(role_id: ,'2')
user.update_attribute(password:, "123456")

end

