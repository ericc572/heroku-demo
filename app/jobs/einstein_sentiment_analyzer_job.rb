class EinsteinSentimentAnalyzerJob < ActiveJob::Base
  queue_as :default

  def perform(contact_id, comment)
    puts "performing sentiment analysis...."
    EinsteinSentimentAnalyzer.new(contact_id, comment).run
  end
end
