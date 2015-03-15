module SportsDataApi
  module Mlb

    class Exception < ::Exception
    end

    DIR = File.join(File.dirname(__FILE__), 'mlb')
    BASE_URL = 'http://api.sportsdatallc.org/mlb-%{access_level}%{version}'
    DEFAULT_VERSION = 5
    SPORT = :mlb

    # autoload :Team, File.join(DIR, 'team')
    # autoload :Teams, File.join(DIR, 'teams')
    # autoload :Player, File.join(DIR, 'player')
    # autoload :Players, File.join(DIR, 'players')
    # autoload :Game, File.join(DIR, 'game')
    # autoload :Games, File.join(DIR, 'games')
    # autoload :Season, File.join(DIR, 'season')
    # autoload :Broadcast, File.join(DIR, 'broadcast')
    # autoload :GameStat, File.join(DIR,'game_stat')
    # autoload :GameStats, File.join(DIR, 'game_stats')
    # autoload :Boxscore, File.join(DIR, 'boxscore')
    # autoload :Venue, File.join(DIR, 'venue')
    # autoload :Venues, File.join(DIR, 'venues')

    ##
    # Fetches all MLB teams
    def self.teams(version = DEFAULT_VERSION)
      self.response_json(version, "/league/hierarchy.json")
    end

    ##
    # Fetches MLB season schedule for a given year and season
    def self.schedule(year = Date.today.year, season_type = 'REG', version = DEFAULT_VERSION)
      self.response_json(version, "/games/#{year}/#{season_type}/schedule.json")
    end

    ##
    # Fetches MLB daily schedule for a given date
    def self.daily(date = Date.today, version = DEFAULT_VERSION)
      self.response_json(version, "/games/#{date.year}/#{date.month}/#{date.day}/schedule.json")
    end

    ##
    # Fetches MLB venues
    def self.venues(version = DEFAULT_VERSION)
      self.response_json(version, "/league/venues.json")
    end

    ##
    # Fetch MLB game stats
    def self.game_statistics(event_id, version = DEFAULT_VERSION )
      self.response_json(version, "/games/#{event_id}/summary.json")
    end

    ##
    # Fetch MLB Game Boxscore
    def self.game_boxscore(event_id, version = DEFAULT_VERSION )
      self.response_json(version, "/games/#{event_id}/boxscore.json")
    end

    ##
    # Fetches MLB team roster
    def self.team_roster(version = DEFAULT_VERSION)
      self.response_json(version, "/league/full_rosters.json")
    end

    ##
    # Fetches pbp
    def self.play_by_play(event_id, version = DEFAULT_VERSION)
      self.response_json(version, "/games/#{event_id}/pbp.json")
    end


    private

    def self.response_json(version, url)
      base_url = BASE_URL % { access_level: SportsDataApi.access_level(SPORT), version: version }
      response = SportsDataApi.generic_request("#{base_url}#{url}", SPORT)
      JSON.parse(response.to_s)
    end
  end
end
