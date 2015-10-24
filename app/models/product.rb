class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :offers

  has_attached_file :picture, styles: { medium: "600x600>", thumb: "300x300>" }, default_url: "/images/missing_product.png", :storage => :s3, :s3_credentials => Proc.new{|a| a.instance.s3_credentials }, :s3_protocol => 'http'
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  def s3_credentials
    {:bucket => ENV["AWS_BUCKET"], :access_key_id => ENV["AWS_ACCESS_KEY_ID"], :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]}
  end
end
