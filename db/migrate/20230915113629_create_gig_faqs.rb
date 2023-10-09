class CreateGigFaqs < ActiveRecord::Migration[7.0]
  def change
    create_table :gig_faqs do |t|
      t.string :question, null: false
      t.string :answer, null: false
      t.references :gig, foreign_key: true

      t.timestamps
    end
  end
end
