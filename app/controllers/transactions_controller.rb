class TransactionsController < ApplicationController
  layout "pages_with_search_bar"

  def index
    @transactions = verified_role.gig_transactions.order('created_at desc')
  end
end
