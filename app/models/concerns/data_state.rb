module DataState
  extend ActiveSupport::Concern
  
  included do
    # any additional values must be added to the end of array
    bitmask :data_state, as: [:checked, :auto, :incomplete, :parish_books,
                              :user_nonchecked, :to_complete_manually,
                              :inflected_surname]
    
    def self.check_boxes_array
      values_for_data_state.map do |state|
        [state, I18n.t("data_states.#{ state }")]
      end
    end
    
    def data_states
      data_state.map do |state|
        I18n.t "data_states.#{ state }"
      end.join(', ')
    end
  end
end
