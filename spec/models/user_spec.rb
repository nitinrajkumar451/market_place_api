require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }
  # letuser = create(:user)   
  it 'is valid with valid attributes' do
    user = User.new
    user.email="beta@incubyte.co"
    user.password_digest="alpha"
    expect(user).to be_valid
  end
  it 'is not valid without email' do
    user = User.new('email'=>nil)
    expect(user).not_to be_valid
  end
  it 'is not valid without password' do

    user = User.new
    user.email="nitin@incubyte.co"
    user.password_digest=""    
    expect(user).not_to be_valid
  end
    
  it 'is not valid with existing email' do
    # pending
    # user = create(:user)   
    user1 = build(:user, email: "alpha@incubyte.co")
    expect(user1).not_to be_valid
    
  end
  it 'should delete product when a user is deleted' do
    product = create(:product)
    initial_count = Product.count
    user.destroy    
    final_count =  Product.count
    expect(final_count-initial_count).to eq(-1)    
  end
end
