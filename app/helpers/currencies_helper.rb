module CurrenciesHelper

  def linked_currencies
    @unlinked = Currency.total_unlinked
    if @unlinked == 0
      return "All currencies linked to countries"
    else
      return "#{pluralize(@unlinked, 'currency')} unlinked to countries" 
    end
  end
end
