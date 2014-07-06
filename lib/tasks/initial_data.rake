namespace :db do
  desc "Fill database with initial data"
  task populate: :environment do
    create_quarters
    create_people_and_graves
    set_grave_types
  end
end

def create_quarters
  Quarter.transaction do
    10.times do |i|
      unless Quarter.find_by(short_name: "k#{i+1}")
        Quarter.create!(name: "Kwatera #{i+1}", short_name: "k#{i+1}")
      end
    end
    
    7.times do |i|
      unless Quarter.find_by(short_name: "p#{i+1}")
        Quarter.create!(name: "Pas #{i+1}", short_name: "p#{i+1}")
      end
    end
  end
end

def create_people_and_graves
  people = File.read('data/people.tsv').split("\n")[1..-1].map { |p| p.split("\t") }
  people.each do |person|
    person_hash = Hash[PersonWithAssociations::KEYS.zip(person)]
    begin
      PersonWithAssociations.new(person_hash).create!
    rescue => e
      puts "The following record wasn't added due to the error below"
      p person_hash
      puts e.inspect
      puts e.backtrace
    end
  end
end

def set_grave_types
  Grave.find_each do |grave|
    grave.set_grave_type!
    grave.data_state = [:auto]
  end
end
