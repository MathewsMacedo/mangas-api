class Serie < ApplicationRecord

    validates :id_serie, presence: true, uniqueness: true
    # validates :cover, presence: true
    # validates :name, presence: true
    # validates :categories, presence: true
    # validates :chapters, presence: true
    # validates :description, presence: true
    # validates :artist, presence: true
    # validates :score, presence: true
    # validates :lang, presence: true
    validates :chapters_all, presence: true

end
