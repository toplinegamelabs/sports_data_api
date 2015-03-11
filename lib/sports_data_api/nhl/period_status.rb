module SportsDataApi
  module Nhl
    class PeriodStatus
      attr_reader :number
      attr_reader :started
      attr_reader :ended

      def initialize(pbp)
        @number = pbp['number'].to_i
        @started = false
        @ended = false
        if pbp['events']
          @started = pbp['events'].select{|event| event['event_type'] == 'faceoff'}.count > 0
          @ended = pbp['events'].select{|event| event['event_type'] == 'endperiod'}.count > 0
        end
      end
    end
  end
end
