module CurrenciesHelper

  def linked_currencies
    @unlinked = Currency.total_unlinked
    if @unlinked == 0
      return "All currencies linked to countries"
    else
      return "#{pluralize(@unlinked, 'currency')} unlinked to countries" 
    end
  end
  
  def currency_name_help
    "Enter the full name of the currency in 50 characters or fewer."
  end
  
  def currency_code_help
    "Enter a three-letter code for the currency.  (Use capital letters.)"
  end
  
  def currency_decimals_help
    "Enter a number showing the number of decimal places normally displayed for the currency."
  end
end
