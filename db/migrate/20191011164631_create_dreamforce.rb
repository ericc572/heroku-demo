class CreateDreamforce < ActiveRecord::Migration[6.0]
  def change
    ActiveRecord::Base.connection.create_schema('salesforce')
  end
end
