class AddTopicsToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :topic, index: true, foreign_key: true
  end
end
