module SportsDataApi
  module Nba
    class Player
      attr_reader :stats

      def initialize(player)
        if player
          player_ivar = self.instance_variable_set("@player", {})
          self.class.class_eval { attr_reader :"player" }
          @stats = SportsDataApi::Stats.new(player.delete('statistics'))

          player.each_pair do |k,v|
            player_ivar[k.to_sym] = v
          end
        end
      end
    end
  end
end
