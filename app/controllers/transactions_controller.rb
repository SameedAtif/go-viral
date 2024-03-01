class TransactionsController < ApplicationController
  def index
    @transactions = verified_role.gig_transactions
  end
end
