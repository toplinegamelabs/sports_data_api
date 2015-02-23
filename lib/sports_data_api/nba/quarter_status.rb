module SportsDataApi
  module Nba
    class QuarterStatus
      attr_reader :number
      attr_reader :started
      attr_reader :ended

      def initialize(xml)
        @number = xml['number'].to_i
        @started = false
        @ended = false
        events = xml.xpath('events/event')
        @started = events.count > 0
        events.each do |event|
          if event['event_type'] == 'endperiod'
            @ended = true
          end
        end
      end
    end
  end
end
