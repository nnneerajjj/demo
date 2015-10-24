class Offer < ActiveRecord::Base
  belongs_to :product

  def self.current_offers
    offers = self.where("start_time < ? AND end_time > ?", Time.now, Time.now)
    now = Time.now
    valid_offers = Array.new
    offers.each do |o|
      offer_valid = false
      if o.repeat == 'daily'
        if ((now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
          offer_valid = true
        end
      elsif o.repeat == 'weekly'
        if ((now.wday == o.start_time.wday) and (now > o.start_time.to_s(:time).to_time) and (now < o.start_time.to_s(:time).to_time + o.duration.send(o.duration_type) ))
          offer_valid = true
        end
      end
      
      if offer_valid
        product_present = false
        valid_offers.each_with_index do |vo, index|
          if vo.product_id == o.product_id
            product_present = true
            if vo.discount_percent < o.discount_percent
              valid_offers[index] = o
            end
          end
        end
        
        valid_offers << o unless product_present
      end
    end
    
    valid_offers
  end
end
