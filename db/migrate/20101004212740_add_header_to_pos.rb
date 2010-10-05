class AddHeaderToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :header, :text
  end

  def self.down
    remove_column :pos, :header
  end
end
