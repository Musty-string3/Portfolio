module WrittenBy
  extend ActiveSupport::Concern

  included do
    def written_by?(current_user)
      user == current_user
    end
  end
end