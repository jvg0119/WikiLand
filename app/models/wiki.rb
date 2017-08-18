class Wiki < ApplicationRecord
  belongs_to :user#, optional: true
  has_many :collaborators, dependent: :destroy
  has_many :wiki_collaborators, through: :collaborators, source: :user

  validates :title, :body, :slug, presence: true

  scope :public_wikis, -> { Wiki.where(private: false) }
  scope :private_wikis, -> (user1){ Wiki.where(private: true).where(user: user1)  } #
  scope :private_wikis_admin, -> { where(private: true) }

  extend FriendlyId
  friendly_id :title, use: :slugged   # :title is the attribute for the slug

end
