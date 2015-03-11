module SportsDataApi
  module Nhl
    class Player
      attr_reader :stats

      def initialize(player)
        if player
          player_ivar = self.instance_variable_set("@player", {})
          self.class.class_eval { attr_reader :"player" }
          @stats = SportsDataApi::Stats.new(player.delete('statistics'))

          goalie_stats = player.delete('goaltending')
          if goalie_stats
            goalie_stats.delete('periods')
            goaltending_ivar = @stats.instance_variable_set("@goaltending", {})
            @stats.class.class_eval { attr_reader :"goaltending" }
            goalie_stats.each_pair do |parent_k, parent_v|
              if parent_v.is_a? Hash
                parent_v.each_pair do |child_k, child_v|
                  goaltending_ivar["#{parent_k}_#{child_k}".to_sym] = child_v
                end
              else
                goaltending_ivar[parent_k.to_sym] = parent_v
              end
            end
          end

          player.each_pair do |k,v|
            player_ivar[k.to_sym] = v
          end
        end
      end
    end
  end
end
