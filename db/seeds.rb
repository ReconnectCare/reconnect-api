# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user_base = [{
  first_name: "Dusty",
  last_name: "Candland",
  password: "password",
  password_confirmation: "password",
  email: "candland@gmail.com",
  confirmed_at: DateTime.now,
  roles: [:user, :admin]
}]

user_base.each do |user_data|
  User.find_or_create_by(email: user_data[:email]) do |user|
    user.update(user_data)
  end
end

Setting.find_or_create_by(name: "providers_to_attempt") do |s|
  s.value = 2
  s.value_type = Setting::VALUE_TYPES.integer
end

Setting.find_or_create_by(name: "provider_text_message") do |s|
  s.value = "Please call <%= conference.number_link %> to join the Reconnect conference with <%= conference.patient_first_name %>"
  s.value_type = Setting::VALUE_TYPES.string
end

Setting.find_or_create_by(name: "provider_voice_greating") do |s|
  s.value = "Press 1 to join the conference with <%= conference.patient_first_name %>"
  s.value_type = Setting::VALUE_TYPES.string
end

Setting.find_or_create_by(name: "conference_has_ended_message") do |s|
  s.value = "The conference has ended. Please wait for the next inbound patient"
  s.value_type = Setting::VALUE_TYPES.string
end

Setting.find_or_create_by(name: "provider_voice_conference_handled_message") do |s|
  s.value = "This call has been handled by another ReconnectCare provider"
  s.value_type = Setting::VALUE_TYPES.string
end

Setting.find_or_create_by(name: "conference_number_area_code") do |s|
  s.value = "954"
  s.value_type = Setting::VALUE_TYPES.string
end
