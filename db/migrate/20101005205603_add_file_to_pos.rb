class AddFileToPos < ActiveRecord::Migration
  def self.up
    add_column :pos, :file, :binary
  end

  def self.down
    remove_column :pos, :file
  end
end
