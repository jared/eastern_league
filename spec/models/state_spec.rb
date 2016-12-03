require 'spec_helper'

RSpec.describe State, type: :model do
  it "should have Alabama" do
    expect(State::NAMES.first).to eq ["Alabama", "AL"]
  end
end
