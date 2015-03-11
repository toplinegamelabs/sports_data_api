module SportsDataApi
  module Nhl
    class PlayerSeasonStats
      attr_reader :team_id, :year, :type, :players

      def initialize(stats)
        if stats
          @year = stats['season']['year'].to_i
          @type = stats['season']['type'].to_sym
          @team_id = stats['id']
          @players = stats['players'].map do |player|
            Player.new(player)
          end
        end
      end
    end
  end
end
