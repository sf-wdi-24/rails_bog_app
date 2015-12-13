class AddAvatarToCreatures < ActiveRecord::Migration
  def change
    add_column :creatures, :avatar, :string
  end
end
