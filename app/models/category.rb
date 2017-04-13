class Category < ActiveRecord::Base
    after_create :create_image
    has_many :article_categories
    has_many :articles, through: :article_categories
    validates :name, presence: true, length: { minimum: 1, maximum: 25 }
    validates_uniqueness_of :name
    mount_uploader :image, ImageUploader

    def create_image
      #images = Dir.entries('public/images')
      #images.delete('.')
      #images.delete('..')
      #self.image = Rails.root.join("public/images/" + images.sample).open

      #image_path = ActionController::Base.helpers.asset_path('diamonds.png') 
      image_path = "public/images/diamonds.png"
      self.image = Rails.root.join(image_path).open
      self.save
    end
end
