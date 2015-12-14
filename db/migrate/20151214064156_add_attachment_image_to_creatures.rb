class AddAttachmentImageToCreatures < ActiveRecord::Migration
  def self.up
    change_table :creatures do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :creatures, :image
  end
end
