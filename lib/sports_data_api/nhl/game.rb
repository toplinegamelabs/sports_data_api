module SportsDataApi
  module Nhl
    class Game
      attr_reader :id, :scheduled, :home, :home_team, :away,
        :away_team, :status, :venue, :broadcast, :year, :season,
        :date, :period, :clock, :period_stats, :period_status

      def initialize(args={})
        game = args.fetch(:game)
        @year = args[:year] ? args[:year].to_i : nil
        @season = args[:season] ? args[:season].to_sym : nil
        @date = args[:date]

        @id = game['id']
        @scheduled = Time.parse(game['scheduled'])
        @status = game['status']
        @clock = game['clock']
        @period = game['period'] ? game['period'].to_i : nil
        @broadcast = Broadcast.new(game['broadcast'])
        @home_team = Team.new(game['home'])
        @away_team = Team.new(game['away'])
        @home = @home_team.id
        @away = @away_team.id
        @venue = Venue.new(game['venue'])
        @period_stats = []
        @period_status = []
        if game['periods']
          game['periods'].each do |period_data|
            @period_stats << PeriodStats.new(period_data)
            @period_status << PeriodStatus.new(period_data)
          end
        end
      end

      ##
      # Wrapper for Nhl.game_summary
      # TODO
      def summary
        Nhl.game_summary(@id)
      end

      ##
      # Wrapper for Nhl.pbp (Nhl.play_by_play)
      # TODO
      def pbp
        raise NotImplementedError
      end

      ##
      # Wrapper for Nhl.boxscore
      # TODO
      def boxscore
        raise NotImplementedError
      end
    end
  end
end
