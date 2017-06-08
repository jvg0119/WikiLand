class Wiki < ApplicationRecord
  belongs_to :user#, optional: true

  validates :title, :body, presence: true

  scope :public_wikis, -> { Wiki.where(private: false) }
  scope :private_wikis, -> { Wiki.where(private: true) }

end
