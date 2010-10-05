class AddPlaceAndMsgstrsToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :place, :text
    add_column :words, :msgstrs, :text
  end

  def self.down
    remove_column :words, :place
    remove_column :words, :msgstrs
  end
end
