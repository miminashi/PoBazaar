class AddPoidToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :poid, :integer
  end

  def self.down
    remove_column :words, :poid
  end
end
