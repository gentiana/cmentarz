RSpec::Matchers.define :respond_to_methods do |*methods|
  match do |model|
    methods.flatten.all? do |method|
      model.respond_to? method
    end
  end
end

RSpec::Matchers.define :have_contents do |*contents|
  match do |page|
    contents.flatten.all? do |content|
      page.has_content? content
    end
  end
end

RSpec::Matchers.define :have_links do |*links|
  match do |page|
    links.flatten.all? do |link|
      page.has_link? link
    end
  end
end

RSpec::Matchers.define :have_grave_select do |*options|
  match do |page|
    page.has_select? simple_label(:grave), options: options
  end
end

RSpec::Matchers.define :have_detected_errors do
  match do |person|
    errors = person.errors
    birth_errors = person.birth_date.errors
    death_errors = person.death_date.errors
    errors.keys.include? :lived
    birth_errors.keys.include? :base
    death_errors.keys.include? :base
    death_errors.keys.include? :year
  end
end

RSpec::Matchers.define :display_errors do |form_title, button_txt|
  match do |page|
    fill_in_date 'person_birth_date', :death_date
    fill_in_date 'person_death_date', :date
    fill_in simple_label(:lived), with: 'qwerty'
    click_button button_txt
    
    page.has_title? form_title
    page.has_selector? ".error_list"
    
    fill_in "person_birth_date_year", with: 1234
    fill_in simple_label(:lived), with: '67'
    click_button button_txt
    
    ! page.has_title? form_title
    page.has_content? '1234'
    page.has_content? '67'
  end
end
