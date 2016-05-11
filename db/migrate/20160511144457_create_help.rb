class CreateHelp < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :title
      t.string :text
    end
  end
end
