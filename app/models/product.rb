# == Schema Information
#
# Table name: products
#
#  id              :integer          not null, primary key
#  product_name    :string
#  price           :integer
#  quantity        :integer
#  instagram_image :string
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  photo_id        :string
#  category_id     :integer          default(1)
#  store_id        :integer
#  deleted_at      :datetime
#

class Product < ActiveRecord::Base
  include PublicActivity::Common

  acts_as_paranoid

  # after_create :magic

  has_shortened_urls

  belongs_to :category

  validates_presence_of :instagram_image,
                        :price,
                        :description,
                        :product_name,
                        :store_id
  validates_numericality_of :price, length: { minimum: 4 }
  validates_numericality_of :quantity, greater_than: 0
  validates :description, length: { maximum: 500 }
  validates_length_of :product_name, :maximum => 40

  # when the user create a product and go back and click again on create
  # this will avoid product duplication
  validates_uniqueness_of :photo_id

  belongs_to :store, touch: true
  has_many :orders

  before_update :product_quantity


  def slug
    store.slug.downcase.gsub(" ", "-") + "_"  + product_name.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  def self.search(search)
    if search
      where("product_name ILIKE ?", "%#{search}%")
    else
      all
    end
  end

  private
    # def magic
    #   # Shortener::ShortenedUrl.generate("/products/#{self.id}", owner: self)
    #   # self.save!
    # end

    def product_quantity
      if self.quantity < 0
        self.quantity = 0
      end
    end
end
