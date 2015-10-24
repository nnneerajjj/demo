class Product < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :offers
  has_many :purchases
  
  attr_accessor :discount_percent

  has_attached_file :picture, styles: { medium: "600x600>", thumb: "300x300>" }, default_url: "/images/missing_product.png", :storage => :s3, :s3_credentials => Proc.new{|a| a.instance.s3_credentials }, :s3_protocol => 'http'
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/

  def s3_credentials
    {:bucket => ENV["AWS_BUCKET"], :access_key_id => ENV["AWS_ACCESS_KEY_ID"], :secret_access_key => ENV["AWS_SECRET_ACCESS_KEY"]}
  end

  def discount_percent
    percent = 0
    now = Time.now

    self.offers.each do |o|
      offer_valid = false
      if((now > o.start_time) and (now < o.end_time))
        if o.repeat == 'daily'
          if ((now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
            offer_valid = true
          end
        elsif o.repeat == 'weekly'
          if ((now.wday == o.start_time.wday) and (now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
            offer_valid = true
          end
        end
        percent = (o.discount_percent > percent) ? o.discount_percent : percent if offer_valid
      end
    end 
    
    percent 
  end

end
