module UsersHelper

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def admin_notes_1
  
    "As an Administrator, your job is to help us set up and maintain the settings for the entire database.  If you also
    have special responsibility for your country, you'll find additional settings when you open your country's pages ... 
    and you'll need to make sure that we're always up-to-date with the latest labor legislation, public holidays, etc."
  end
  
  def admin_notes_2
  
   "Nothing you modify will change existing records, but it will affect new records, so make sure you follow the 
   instructions carefully, and if in doubt about a change or a new entry, please check with the HROomph core team first."
  end
end
