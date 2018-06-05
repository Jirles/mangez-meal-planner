class User < ActiveRecord::Base
  validates :username, uniqueness: true
  has_many :meal_plans
  has_many :recipes
  has_secure_password

  def self.find_by_slug(slug)
    all.detect{|o| o.slug == slug}
  end

  def slug
    username_arr = self.username.split(" ")
    username_arr.collect{|w| w.downcase}.join('-')
  end

end
