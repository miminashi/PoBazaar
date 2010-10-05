class AddCountToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :count, :integer
  end

  def self.down
    remove_column :pos, :count
  end
end
