module TransactionsHelper
  def influencer_transaction_description(trans)
    if trans.influencer_gig_transactions.present?
      "Payment from #{trans.client.user.full_name} for #{trans.gig_package.title}"
    elsif trans.influencer_gig_transactions.blank?
      if trans.transaction_type == 'credit'
        "Payment pending from #{trans.client.user.full_name} for #{trans.gig_package.title}"
      else
        "Payment refund to #{trans.client.user.full_name} for #{trans.gig_package.title}"
      end
    end
  end

  def influencer_transaction_status(trans)
    if trans.influencer_gig_transactions.present?
      "completed"
    elsif trans.influencer_gig_transactions.blank?
      if trans.transaction_type == 'credit'
        "pending"
      else
        "refunded"
      end
    end
  end

  def format_transaction_amount(trans)
    if trans.influencer_gig_transactions.present?
      number_to_currency(trans.influencer_gig_transactions.gross_price)
    elsif trans.influencer_gig_transactions.blank?
      if trans.transaction_type == 'credit'
        "#{number_to_currency(trans.gross_price)}"
      else
        "-#{number_to_currency(trans.gross_price)}"
      end
    end
  end

  def format_transaction_time(trans)
    trans.created_at.strftime("%F %T")
  end
end
