module SportsDataApi
  module Nba

    class Exception < ::Exception
    end

    DIR = File.join(File.dirname(__FILE__), 'nba')
    BASE_URL = 'http://api.sportsdatallc.org/nba-%{access_level}%{version}'
    DEFAULT_VERSION = 3
    SPORT = :nba

    autoload :Team, File.join(DIR, 'team')
    autoload :Teams, File.join(DIR, 'teams')
    autoload :Player, File.join(DIR, 'player')
    autoload :Game, File.join(DIR, 'game')
    autoload :Games, File.join(DIR, 'games')
    autoload :Season, File.join(DIR, 'season')
    autoload :Venue, File.join(DIR, 'venue')
    autoload :Broadcast, File.join(DIR, 'broadcast')
    autoload :QuarterStats, File.join(DIR, 'quarter_stats')
    autoload :QuarterStatus, File.join(DIR, 'quarter_status')
    autoload :PlayerSeasonStats, File.join(DIR, 'player_season_stats')

    ##
    # Fetches NBA season schedule for a given year and season
    def self.schedule(year, season, version = DEFAULT_VERSION)
      season = season.to_s.upcase.to_sym
      raise SportsDataApi::Nba::Exception.new("#{season} is not a valid season") unless Season.valid?(season)

      response = self.response_json(version, "/games/#{year}/#{season}/schedule.json")

      return Season.new(response)
    end

    ##
    # Fetches NBA team roster
    def self.team_roster(team, version = DEFAULT_VERSION)
      response = self.response_json(version, "/teams/#{team}/profile.json")

      return Team.new(response)
    end

    ##
    # Fetches NBA game summary for a given game
    def self.game_summary(game, version = DEFAULT_VERSION)
      response = self.response_json(version, "/games/#{game}/summary.json")

      return Game.new(game: response)
    end

    ##
    # Fetches all NBA teams
    def self.teams(version = DEFAULT_VERSION)
      response = self.response_json(version, "/league/hierarchy.json")

      return Teams.new(response)
    end

    ##
    # Fetches NBA daily schedule for a given date
    def self.daily(year, month, day, version = DEFAULT_VERSION)
      response = self.response_json(version, "/games/#{year}/#{month}/#{day}/schedule.json")

      return Games.new(response)
    end

    ##
    # Fetches NBA stats by quarter for a given game
    def self.quarter_stats(game, version = DEFAULT_VERSION)
      response = self.response_json(version, "/games/#{game}/pbp.json")

      return Game.new(game: response)
    end

    ##
    # Fetches NBA season stats for a given team
    def self.season_stats(year, season, team, version = DEFAULT_VERSION)
      response = self.response_json(version, "/seasontd/#{year}/#{season}/teams/#{team}/statistics.json")

      return PlayerSeasonStats.new(response)
    end


    private

    def self.response_json(version, url)
      base_url = BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
      response = SportsDataApi.generic_request("#{base_url}#{url}", SPORT)
      JSON.parse(response.to_s)
    end
  end
end
