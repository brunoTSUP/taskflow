class CreateWebsites < ActiveRecord::Migration[8.1]
  def change
    create_table :websites do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
