module SportsDataApi
  module Nhl
    class Season
      attr_reader :id, :year, :type, :games

      def initialize(schedule)
        @id = schedule['season']['id']
        @year = schedule['season']['year'].to_i
        @type = schedule['season']['type'].to_sym

        @games = schedule['games'].map do |game|
          Game.new(year: @year, season: @type, game: game)
        end
      end

      ##
      # Check if the requested season is a valid
      # NHL season type.
      #
      # The only valid types are: :pre, :reg, :pst
      def self.valid?(season)
        [:PRE, :REG, :PST].include?(season)
      end
    end
  end
end
