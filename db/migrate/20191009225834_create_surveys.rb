class CreateSurveys < ActiveRecord::Migration[6.0]
  def change
    create_table :surveys do |t|
      t.string :question_id
      t.string :answer_type
      t.string :answer
      t.string :field

      t.timestamps
    end
  end
end
