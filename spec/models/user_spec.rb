require 'rails_helper'

RSpec.describe User, type: :model do
  context "Validation" do
    let!(:user) {User.new}
    
    it "1. is not valid without name" do
      user.email = "john@email.com"
      user.role = "user"
      expect(user).to_not be_valid
    end
    
    it "2. is not valid without email" do
      user.name = "John"
      user.role = "user"
      expect(user).to_not be_valid
    end
    
    it "3. is not valid without role" do
      user.name = "John"
      user.email = "john@email.com"
      expect(user).to_not be_valid
    end
    
    it "4. is not valid if role is not among the intended choices (user/admin/superadmin)" do
      user.name = "John"
      user.email = "john@email.com"
      user.role = "should_not_be_valid"
      expect(user).to_not be_valid
    end

    it "5. is valid if all fields are present" do
      user.name = "John"
      user.email = "john@email.com"
      user.role = "user"
      expect(user).to_not be_valid
    end
  end
end
