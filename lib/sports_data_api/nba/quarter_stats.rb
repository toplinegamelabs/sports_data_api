module SportsDataApi
  module Nba
    class QuarterStats
      attr_reader :number
      attr_reader :player_stats

      def initialize(xml)
        @number = xml['number'].to_i
        @player_stats = {}
        xml.xpath('events/event').each do |event|
          if should_process_event?(event['event_type'])
            self.send("process_#{event['event_type']}", event.xpath('statistics').first)
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

      def process_twopointmade(stats)
        player = stats.xpath('fieldgoal/player').first
        if player
          add_stat(player['id'], :field_goals_made)
          add_stat(player['id'], :two_points_made)
          add_stat(player['id'], :points, 2)
        end
        player = stats.xpath('assist/player').first
        add_stat(player['id'], :assists) if player
      end

      def process_threepointmade(stats)
        player = stats.xpath('fieldgoal/player').first
        if player
          add_stat(player['id'], :field_goals_made)
          add_stat(player['id'], :three_points_made)
          add_stat(player['id'], :points, 3)
        end
        player = stats.xpath('assist/player').first
        add_stat(player['id'], :assists) if player
      end

      def process_freethrowmade(stats)
        player = stats.xpath('freethrow/player').first
        if player
          add_stat(player['id'], :free_throws_made)
          add_stat(player['id'], :points)
        end
      end

      def process_rebound(stats)
        player = stats.xpath('rebound/player').first
        add_stat(player['id'], :rebounds) if player
      end

      def process_turnover(stats)
        player = stats.xpath('turnover/player').first
        add_stat(player['id'], :turnovers) if player
        player = stats.xpath('steal/player').first
        add_stat(player['id'], :steals) if player
      end

      def process_twopointmiss(stats)
        player = stats.xpath('block/player').first
        add_stat(player['id'], :blocks) if player
      end

      def process_threepointmiss(stats)
        player = stats.xpath('block/player').first
        add_stat(player['id'], :blocks) if player
      end
    end
  end
end
