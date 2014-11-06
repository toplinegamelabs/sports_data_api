module SportsDataApi
  module Nfl
    class GameRoster
      attr_reader :home_players, :away_players
      def initialize(json)
        @home_players = []
        @away_players = []
        json["home_team"]["players"].each do |player|
          @home_players << Player.new(player)
        end
        json["away_team"]["players"].each do |player|
          @away_players << Player.new(player)
        end
      end
    end
  end
end
