module NationalitiesHelper

  def linked_nationalities
    @unlinked = Nationality.total_unlinked
    if @unlinked == 0
      return "All nationalities linked to countries"
    else
      return "#{pluralize(@unlinked, 'nationality')} unlinked to countries." 
    end
  end
  
end
