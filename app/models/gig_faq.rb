class GigFaq < ApplicationRecord
  belongs_to :gig

  validates_presence_of :question, :answer
  validates_length_of :question, :answer, minimum: 3
end
