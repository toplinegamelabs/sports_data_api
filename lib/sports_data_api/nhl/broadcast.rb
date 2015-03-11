module SportsDataApi
  module Nhl
    class Broadcast
      attr_reader :network, :satellite
      def initialize(broadcast)
        if broadcast
          @network = broadcast['network']
          @satellite = broadcast['satellite']
        end
      end
    end
  end
end
