module SportsDataApi
  module Nba
    class QuarterStats
      attr_reader :number
      attr_reader :player_stats

      def initialize(pbp)
        @number = pbp['number'].to_i
        @player_stats = {}
        if pbp['events']
          pbp['events'].each do |event|
            if should_process_event?(event['event_type']) && event['statistics']
              event['statistics'].each do |stat|
                self.send("process_#{stat['type']}", stat) if stat['player']
              end
            end
          end
        end
      end

      private

      def should_process_event?(event_type)
        ['twopointmade', 'threepointmade', 'freethrowmade', 'rebound',
         'turnover', 'twopointmiss', 'threepointmiss'].include?(event_type)
      end

      def add_stat(player_id, stat, amount=1)
        @player_stats[player_id] ||= init_player_stats
        @player_stats[player_id][stat] += amount
      end

      def init_player_stats
        {
          :field_goals_made => 0,
          :two_points_made => 0,
          :three_points_made => 0,
          :free_throws_made => 0,
          :rebounds => 0,
          :assists => 0,
          :turnovers => 0,
          :steals => 0,
          :blocks => 0,
          :points => 0
        }
      end

      def process_fieldgoal(stats)
        if stats['made']
          add_stat(stats['player']['id'], :field_goals_made)
          if stats['three_point_shot']
            add_stat(stats['player']['id'], :three_points_made)
            add_stat(stats['player']['id'], :points, 3)
          else
            add_stat(stats['player']['id'], :points, 2)
          end
        end
      end

      def process_rebound(stats)
        add_stat(stats['player']['id'], :rebounds)
      end

      def process_assist(stats)
        add_stat(stats['player']['id'], :assists)
      end

      def process_block(stats)
        add_stat(stats['player']['id'], :blocks)
      end

      def process_attemptblocked(stats)
      end

      def process_freethrow(stats)
        if stats['made']
          add_stat(stats['player']['id'], :free_throws_made)
          add_stat(stats['player']['id'], :points)
        end
      end

      def process_turnover(stats)
        add_stat(stats['player']['id'], :turnovers)
      end

      def process_steal(stats)
        add_stat(stats['player']['id'], :steals)
      end
    end
  end
end
