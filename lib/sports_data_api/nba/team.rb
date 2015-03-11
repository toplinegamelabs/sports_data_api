module SportsDataApi
  module Nba
    class Team
      attr_reader :id, :name, :market, :alias, :conference, :division,
                  :stats, :players, :points

      def initialize(team, conference = nil, division = nil)
        @id = team['id']
        @name = team['name']
        @market = team['market']
        @alias = team['alias']
        @points = team['points'] ? team['points'].to_i : nil
        @conference = conference
        @division = division
        if team['players']
          @players = team['players'].map do |player|
            Player.new(player)
          end
        else
          @players = []
        end
      end

      ##
      # Compare the Team with another team
      def ==(other)
        # Must have an id to compare
        return false if self.id.nil?

        if other.is_a? SportsDataApi::Nba::Team
          return false if other.id.nil?
          self.id === other.id
        elsif other.is_a? Symbol
          self.id.to_sym === other
        else
          super(other)
        end
      end
    end
  end
end
