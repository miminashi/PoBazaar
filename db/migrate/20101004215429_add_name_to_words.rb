class AddNameToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :name, :string
  end

  def self.down
    remove_column :words, :name
  end
end

