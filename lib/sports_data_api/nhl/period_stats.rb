module SportsDataApi
  module Nhl
    class PeriodStats
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
        ['hit', 'shotsaved', 'penalty', 'goal', 'faceoff', 'shotmissed',
          'emptynetgoal', 'penaltygoal', 'penaltyshotsaved'].include?(event_type)
      end

      def add_stat(player_id, stat, amount=1)
        @player_stats[player_id] ||= init_player_stats
        @player_stats[player_id][stat] += amount
      end

      def init_player_stats
        {
          :goals => 0,
          :assists => 0,
          :penalty_minutes => 0,
          :shots => 0,
          :hits => 0,
          :points => 0,
          :pp_goals => 0,
          :pp_assists => 0,
          :pp_points => 0,
          :blocked_shots => 0,
          :faceoffs_won => 0,
          :faceoffs_lost => 0,
          :saves => 0,
          :goals_against => 0
        }
      end

      def process_faceoff(stats)
        if stats['win']
          add_stat(stats['player']['id'], :faceoffs_won)
        else
          add_stat(stats['player']['id'], :faceoffs_lost)
        end
      end

      def process_shotmissed(stats)
      end

      def process_shot(stats)
        add_stat(stats['player']['id'], :shots)
        if stats['goal']
          add_stat(stats['player']['id'], :goals)
          add_stat(stats['player']['id'], :points)
          if stats['strength'] == 'powerplay'
            add_stat(stats['player']['id'], :pp_goals)
            add_stat(stats['player']['id'], :pp_points)
          end
        end
      end

      def process_shotagainst(stats)
        add_stat(stats['player']['id'], :saves) if stats['saved']
        add_stat(stats['player']['id'], :goals_against) if stats['goal']
      end

      def process_assist(stats)
        add_stat(stats['player']['id'], :assists)
        add_stat(stats['player']['id'], :points)
        if stats['strength'] == 'powerplay'
          add_stat(stats['player']['id'], :pp_assists)
          add_stat(stats['player']['id'], :pp_points)
        end
      end

      def process_hit(stats)
        add_stat(stats['player']['id'], :hits)
      end

      def process_block(stats)
        add_stat(stats['player']['id'], :blocked_shots)
      end

      def process_attemptblocked(stats)
      end

      def process_penalty(stats)
        add_stat(stats['player']['id'], :penalty_minutes, stats['minutes'])
      end
    end
  end
end
