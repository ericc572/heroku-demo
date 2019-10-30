class AddHerokuUuidToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contact, :heroku_uuid, :uuid
  end
end
