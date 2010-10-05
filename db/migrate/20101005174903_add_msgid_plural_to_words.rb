class AddMsgidPluralToWords < ActiveRecord::Migration
  def self.up
    add_column :words, :msgid_plural, :text
  end

  def self.down
    remove_column :words, :msgid_plural
  end
end
