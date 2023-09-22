class ClientProjectTransaction < ApplicationRecord
  belongs_to :system_project_transaction
  belongs_to :project
  belongs_to :project_application
  belongs_to :client

  TRANSACTION_TYPES_MAP = {
    credit: 'credit',
    debit: 'debit'
  }.freeze
  TRANSACTION_TYPES = TRANSACTION_TYPES_MAP.values

  validates_presence_of :gross_price, :fee, :transaction_token, :transaction_type
  validates_numericality_of :fee, :gross_price, only_float: true, greater_than_or_equal_to: 0.00
  validates_inclusion_of :transaction_type, in: TRANSACTION_TYPES

  def readonly?
    !new_record?
  end
end
