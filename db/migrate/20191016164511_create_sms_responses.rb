class CreateSmsResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :sms_responses do |t|
      t.string :phone_number
      t.string :question
      t.string :response_timestamp
      t.string :response_choice
      t.string :response_answer


      t.timestamps
    end
  end
end
