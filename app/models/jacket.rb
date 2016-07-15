class Jacket < ActiveRecord::Base

# LEGACY PRICING, <= 2015 Season
  # PRICES = {
  #   :j354 => { "xs" => 37.50, "s" => 37.50, "m" => 37.50, "l" => 37.50, "xl" => 37.50, "2xl" => 39.00, "3xl" => 42.00, "4xl" => 43.50, "5xl" => 46.00, "6xl" => 47.50},
  #   :sjf  => { "xs" => 16.00, "s" => 16.00, "m" => 16.00, "l" => 16.00, "xl" => 16.00, "2xl" => 17.50, "3xl" => 17.50, "4xl" => 17.50, "5xl" => 17.50, "6xl" => 17.50},
  #   :svf  => { "xs" => 13.50, "s" => 13.50, "m" => 13.50, "l" => 13.50, "xl" => 13.50, "2xl" => 15.00, "3xl" => 15.00, "4xl" => 15.00, "5xl" => 15.00, "6xl" => 15.00}
  # }

  PRICES = {
    :j354 => { "xs" => 21.50, "s" => 21.50, "m" => 21.50, "l" => 21.50, "xl" => 21.50, "2xl" => 23.00, "3xl" => 26.00, "4xl" => 27.50, "5xl" => 28.00, "6xl" => 29.50},
    :sjf  => { "xs" => 0.00, "s" => 0.00, "m" => 0.00, "l" => 0.00, "xl" => 0.00, "2xl" => 0.00, "3xl" => 0.00, "4xl" => 0.00, "5xl" => 0.00, "6xl" => 0.00},
    :svf  => { "xs" => 0.00, "s" => 0.00, "m" => 0.00, "l" => 0.00, "xl" => 0.00, "2xl" => 0.00, "3xl" => 0.00, "4xl" => 0.00, "5xl" => 0.00, "6xl" => 0.00}
  }

  belongs_to :season
  has_one :line_item, :as => :purchasable

  validates_presence_of :style, :size

  before_save :calculate_price

  private

  def calculate_price
    self[:price] = PRICES[style.downcase.to_sym][size.downcase]
  end

end
