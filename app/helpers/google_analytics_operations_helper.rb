module GoogleAnalyticsOperationsHelper
  def average_transaction_value(transactions_total_value, transactions_count)
    return 0 if transactions_count.zero?

    transactions_total_value.to_f / transactions_count
  end

  def conversion_rate(sucesses, total)
    return 0 if total.zero?

    (sucesses.to_f / total) * 100
  end

  def roi(costs, revenue)
    return 0 if costs.zero?

    (revenue.to_f - costs) / costs * 100
  end

  def costs(sent_emails)
    # 50 CZK za 1000 odeslanych emailu bylo v zadání
    50 * sent_emails / 1000.0
  end
end
