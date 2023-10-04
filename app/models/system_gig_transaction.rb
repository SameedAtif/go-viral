class SystemGigTransaction < ApplicationRecord
  belongs_to :gig_package
  belongs_to :client
  belongs_to :gig_dispute, optional: true

  has_many :gig_clients

  TRANSACTION_TYPES_MAP = {
    credit: 'credit', # credit = going in to the wallet
    debit: 'debit' # debit = out of the wallet (to bank or other user)
  }.freeze
  TRANSACTION_TYPES = TRANSACTION_TYPES_MAP.values

  validates_presence_of :gross_price, :fee, :transaction_token, :transaction_type
  validates_numericality_of :fee, :gross_price, only_float: true, greater_than_or_equal_to: 0.00
  validates_inclusion_of :transaction_type, in: TRANSACTION_TYPES

  after_create_commit :create_gig_client

  def readonly?
    !new_record?
  end

  private

  def create_gig_client
    GigClient.create!(
      system_gig_transaction: self,
      gig: gig_package.gig,
      client: client,
      gig_package: gig_package
    )
  end
end
