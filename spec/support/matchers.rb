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
