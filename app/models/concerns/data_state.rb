module DataState
  extend ActiveSupport::Concern
  
  included do
    # any additional values must be added to the end of array
    bitmask :data_state, as: [:checked, :auto, :incomplete, :parish_books,
                              :user_nonchecked]
  end
end