class RenameWordsColumn < ActiveRecord::Migration
  def self.up
    rename_column :words, :type, :msg_type
  end

  def self.down
    rename_column :words, :msg_type, :type
  end
end
