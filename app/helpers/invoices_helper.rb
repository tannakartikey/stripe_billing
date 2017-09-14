module InvoicesHelper

  def invoice_date invoice
    convert_to_date invoice.date
  end

  def invoice_total invoice
    number_to_currency(invoice.total/100, negative_format: "(%u%n)")
  end

  def invoice_period_start invoice
    convert_to_date invoice.lines.data[0].period.start
  end

  def invoice_period_end invoice
    convert_to_date invoice.lines.data[0].period.end
  end

  def invoice_paid? invoice
    invoice.paid == true ? 'Paid' : 'Unpaid'
  end

end
