# require 'support/utilities'

shared_examples_for 'data state' do
  it { should respond_to_methods [:data_state, :data_state?] }
  its(:class) do
    should respond_to_methods [:no_data_state, :with_data_state,
                               :values_for_data_state]
  end

  specify 'should be checked by default' do
    expect(subject.data_state).to eq([:checked])
  end

  specify 'can be filtered' do
    subject.data_state << :parish_books
    subject.save
    expect(subject.class.with_data_state(:parish_books)).to include(subject)
  end

  describe '.check_boxes_array' do
    it 'should map all data states' do
      states = subject.class.check_boxes_array
      keys = states.map(&:first)
      expect(keys.sort).to eq subject.class.values_for_data_state.sort
    end
  end

  describe '#data_states' do
    it 'should return empty string when no states' do
      subject.data_state = []
      expect(subject.data_states).to eq ''
    end

    it 'should return translated and joined data states' do
      subject.data_state = [:checked, :parish_books]
      expect(subject.data_states).to eq 'sprawdzone, na podstawie ksiąg parafialnych'
    end
  end
end
