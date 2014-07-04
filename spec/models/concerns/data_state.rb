# require 'support/utilities'

shared_examples_for "data state" do
  it { should respond_to_methods [:data_state, :data_state?]}
  its(:class) { should respond_to_methods [:no_data_state, :with_data_state,
                                           :values_for_data_state]}
                                           
  specify "should be checked by default" do
    expect(subject.data_state).to eq([:checked])
  end
  
  specify "can be filtered" do
    subject.data_state << :parish_books
    subject.save
    expect(subject.class.with_data_state(:parish_books)).to include(subject)
  end
end
