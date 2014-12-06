module SportsDataApi
  module Nhl
    class PeriodStats
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
        ['hit', 'shotsaved', 'giveaway', 'penalty', 'takeaway', 'goal',
         'faceoff', 'shotmissed'].include?(event_type)
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
          :giveaways => 0,
          :takeaways => 0,
          :points => 0,
          :powerplay_goals => 0,
          :powerplay_assists => 0,
          :powerplay_points => 0,
          :blocked_shots => 0,
          :faceoffs_won => 0,
          :faceoffs_lost => 0
        }
      end

      def process_shotsaved(stats)
        player = stats.xpath('shot/player').first
        add_stat(player['id'], :shots) if player
      end

      def process_hit(stats)
        player = stats.xpath('hit/player').first
        add_stat(player['id'], :hits) if player
      end

      def process_giveaway(stats)
        player = stats.xpath('giveaway/player').first
        add_stat(player['id'], :giveaways) if player
      end

      def process_penalty(stats)
        minutes = stats.xpath('penalty').first.attr('minutes').to_i
        player = stats.xpath('penalty/player').first
        add_stat(player['id'], :penalty_minutes, minutes) if player
      end

      def process_takeaway(stats)
        player = stats.xpath('takeaway/player').first
        add_stat(player['id'], :takeaways) if player
      end

      def process_goal(stats)
        strength = stats.xpath('shot').first.attr('strength')
        player = stats.xpath('shot/player').first
        if player
          add_stat(player['id'], :shots)
          add_stat(player['id'], :goals)
          add_stat(player['id'], :points)
          if strength == 'powerplay'
            add_stat(player['id'], :powerplay_goals)
            add_stat(player['id'], :powerplay_points)
          end
        end
        stats.xpath('assist').each do |assist_stat|
          player = assist_stat.xpath('player').first
          if player
            add_stat(player['id'], :assists)
            add_stat(player['id'], :points)
            if strength == 'powerplay'
              add_stat(player['id'], :powerplay_assists)
              add_stat(player['id'], :powerplay_points)
            end
          end
        end
      end

      def process_faceoff(stats)
        stats.xpath('faceoff').each do |faceoff_stat|
          player = faceoff_stat.xpath('player').first
          if player && faceoff_stat.attr('win') == 'true'
            add_stat(player['id'], :faceoffs_won)
          elsif player && faceoff_stat.attr('win') == 'false'
            add_stat(player['id'], :faceoffs_lost)
          end
        end
      end

      def process_shotmissed(stats)
        blocked_shot = stats.xpath('block').first
        if blocked_shot
          player = blocked_shot.xpath('player').first
          add_stat(player['id'], :blocked_shots) if player
        end
      end
    end
  end
end
