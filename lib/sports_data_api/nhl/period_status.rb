module SportsDataApi
  module Nhl
    class PeriodStatus
      attr_reader :number
      attr_reader :started
      attr_reader :ended

      def initialize(xml)
        @number = xml['number'].to_i
        @started = false
        @ended = false
        xml.xpath('events/event').each do |event|
          if should_process_event?(event['event_type'])
            self.send("process_#{event['event_type']}", event)
          end
        end
      end

      private

      def should_process_event?(event_type)
        ['faceoff', 'endperiod'].include?(event_type)
      end

      def process_faceoff(event)
        if @started
          # do nothing
        else
          @started == true if event['clock'] == '20:00'
        end
      end

      def process_endperiod(event)
        @ended == true
      end
    end
  end
end
