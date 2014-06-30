RSpec::Matchers.define "respond_to_methods" do |*arrays|
  match do |model|
    arrays.flatten.each do |method|
      expect(model).to respond_to method
    end
  end
end

def factory_to_s(factory_name)
  FactoryGirl.build(factory_name).to_s
end

def birth_date(year, month=nil, day=nil)
  BirthDate.new(year: year, month: month, day: day)
end
