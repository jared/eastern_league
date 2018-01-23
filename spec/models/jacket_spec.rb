require 'spec_helper'

describe Jacket do
  context "calculate price" do
    it "should calculate the price for a jacket" do
      # VALID for 2016; may need updating in future seasons
      expectations = [
        { style: "J354", size: "M",   price: 40.00 },
        { style: "J354", size: "2XL", price: 42.00 },
        { style: "SJF",  size: "XS",  price: 16.00 },
        { style: "SJF",  size: "3XL", price: 17.50 },
        { style: "SVF",  size: "XS",  price: 13.50 },
        { style: "SVF",  size: "3XL", price: 15.00 },
      ]

      expectations.each do |attrs|
        @jacket = Jacket.new(style: attrs[:style], size: attrs[:size])
        @jacket.save
        expect(@jacket.price).to eq attrs[:price]
      end
    end
  end
end
