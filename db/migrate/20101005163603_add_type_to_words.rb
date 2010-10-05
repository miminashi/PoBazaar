class AddTypeToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :type, :string
  end

  def self.down
    remove_column :words, :type
  end
end
