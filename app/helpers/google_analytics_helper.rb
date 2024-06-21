module GoogleAnalyticsHelper
  def average_transaction_value(transactions_count, transactions_total_value)
    return 0 if transactions_count.zero?

    transactions_total_value.to_f / transactions_count
  end

  def conversion_rate(add_to_carts, transactions)
    return 0 if add_to_carts.zero?

    (transactions.to_f / add_to_carts) * 100
  end

  def roi(costs, revenue)
    return 0 if costs.zero?

    (revenue.to_f - costs) / costs * 100
  end
end
