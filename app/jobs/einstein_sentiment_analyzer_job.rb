class EinsteinSentimentAnalyzerJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    puts "performing sentiment analysis...."
    EinsteinSentimentAnalyzer.new(comment).run
  end
end
