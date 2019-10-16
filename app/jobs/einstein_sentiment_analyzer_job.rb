class EinsteinSentimentAnalyzerJob < ActiveJob::Base
  queue_as :default

  def perform(comment)
    EinsteinSentimentAnalyzer.new(comment).run
  end
end
