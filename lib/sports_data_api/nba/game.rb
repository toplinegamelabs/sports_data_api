module SportsDataApi
  module Nba
    class Game
      attr_reader :id, :scheduled, :home, :home_team, :away,
        :away_team, :status, :venue, :broadcast, :year, :season,
        :date, :quarter, :clock, :quarter_stats, :quarter_status

      def initialize(args={})
        game = args.fetch(:game)
        @year = args[:year] ? args[:year].to_i : nil
        @season = args[:season] ? args[:season].to_sym : nil
        @date = args[:date]

        @id = game['id']
        @scheduled = Time.parse(game['scheduled'])
        @status = game['status']
        @clock = game['clock']
        @quarter = game['quarter'] ? game['quarter'].to_i : nil
        @broadcast = Broadcast.new(game['broadcast'])
        @home_team = Team.new(game['home'])
        @away_team = Team.new(game['away'])
        @home = @home_team.id
        @away = @away_team.id
        @venue = Venue.new(game['venue'])
        @quarter_stats = []
        @quarter_status = []
        if game['periods']
          game['periods'].each do |quarter_data|
            @quarter_stats << QuarterStats.new(quarter_data)
            @quarter_status << QuarterStatus.new(quarter_data)
          end
        end
      end

      ##
      # Wrapper for Nba.game_summary
      # TODO
      def summary
        Nba.game_summary(@id)
      end

      ##
      # Wrapper for Nba.pbp (Nba.play_by_play)
      # TODO
      def pbp
        raise NotImplementedError
      end

      ##
      # Wrapper for Nba.boxscore
      # TODO
      def boxscore
        raise NotImplementedError
      end
    end
  end
end
