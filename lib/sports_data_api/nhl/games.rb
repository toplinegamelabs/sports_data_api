module SportsDataApi
  module Nhl
    class Games
      include Enumerable
      attr_reader :games, :date

      def initialize(schedule)
        @date = schedule['date']

        @games = schedule['games'].map do |game|
          Game.new(date: @date, game: game)
        end
      end

      def each &block
        @games.each do |game|
          if block_given?
            block.call game
          else
            yield game
          end
        end
      end
    end
  end
end
