FactoryBot.define do
  factory(:user) do
    email { "sample@email.com" }
    password { "my_password" }
    name { "testuser" }
    phone_number { "1234431" }
    role { "admin" }
  end
end 