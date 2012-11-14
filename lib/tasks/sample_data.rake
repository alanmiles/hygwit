namespace :db do
  desc "Fill database with set-up data"
  task populate: :environment do
    make_users
    make_sectors
    make_absences
    make_nationalities
    make_currencies
    make_countries
    make_jobfamilies
    make_qualities
    update_descriptors
    make_contracts
    make_leaving_reasons
    make_grievance_types
    make_disciplinary_categories
  end
end  

def make_users 
  @admin = User.create!(name: "Alan Miles",
                         email: "alan@hroomph.com",
                         password: "foobar",
                         password_confirmation: "foobar")
  @admin.toggle!(:admin)
  @admin.toggle!(:superuser)
end

def make_sectors
  lines = File.new('public/data/sectors.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Sector.create!(params)
  end
end

def make_absences
  lines = File.new('public/data/absences.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    AbsenceType.create!(params)
  end
end

def make_nationalities
  lines = File.new('public/data/nationalities.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Nationality.create!(params)
  end
end

def make_currencies
  lines = File.new('public/data/currencies.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Currency.create!(params)
  end
end

def make_countries
  lines = File.new('public/data/countries.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|

    values = line.strip.split(';')
    @country = values[0]
    @nat = values[1]
    @cur = values[2]
    @rules = values[3]
    @nationality = Nationality.find_by_nationality(@nat)
    @currency = Currency.find_by_code(@cur)
    @attr =  { :country => @country, :nationality_id => @nationality.id, :currency_id => @currency.id, :rules => @rules }
    Country.create(@attr)
  end
end

def make_jobfamilies
  lines = File.new('public/data/jobfamilies.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Jobfamily.create!(params)
  end
end

def make_qualities
  lines = File.new('public/data/qualities.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Quality.create!(params)
  end
end

def update_descriptors
  lines = File.new('public/data/descriptors.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')  
    @qlt = values[0]
    @grade = values[1]
    @desc = values[2]
    @quality = Quality.find_by_quality(@qlt)
    unless @quality == nil
      @descriptor = Descriptor.find_by_quality_id_and_grade(@quality.id, @grade)
      @descriptor.update_attributes(descriptor: @desc, reviewed: true, updated_by: 1)
    end
  end
end

def make_contracts
  lines = File.new('public/data/contracts.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    Contract.create!(params)
  end
end

def make_leaving_reasons
  lines = File.new('public/data/leaving_reasons.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    LeavingReason.create!(params)
  end
end

def make_grievance_types
  lines = File.new('public/data/grievance_types.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    GrievanceType.create!(params)
  end
end

def make_disciplinary_categories
  lines = File.new('public/data/disciplinary_categories.csv').readlines
  header = lines.shift.strip
  keys = header.split(';')
  lines.each do |line|
    params = {}
    values = line.strip.split(';')
    keys.each_with_index do |key, i|
      params[key] = values[i]
    end
    DisciplinaryCategory.create!(params)
  end
end
