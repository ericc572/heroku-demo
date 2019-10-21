class TillSendSmsJob < ActiveJob::Base
  queue_as :default

  def perform(phone_number)
    puts "PERFORM 2 WAY SMS DELIVERY"
    TillSendSms.new(phone_number).run
  end
end
