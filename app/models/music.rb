class Music < Product
    scope :visible, ->(){ where(showing: true) }
end
