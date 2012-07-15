class LineItem < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :order
  belongs_to :purchasable, :polymorphic => true

end
