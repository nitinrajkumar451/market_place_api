require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:user) { create(:user) }
  it "should have a positive product price" do
    product = create(:product)
    product.price=-1.to_i
    expect(product).not_to be_valid
  end
end
