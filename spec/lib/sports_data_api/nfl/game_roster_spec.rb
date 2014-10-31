require 'spec_helper'

describe SportsDataApi::Nfl::GameRoster, vcr: {
    cassette_name: 'sports_data_api_nfl_game_roster',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  before do
    SportsDataApi.set_key(:nfl, api_key(:nfl))
    SportsDataApi.set_access_level(:nfl, 't')
  end

  let(:some_player) { SportsDataApi::Nfl.game_roster(2012, :REG, 9, 'IND', 'MIA').home_players.last.player }

  describe 'game_roster' do
    it "has joined attribute" do
      expect(some_player[:played]).to eq true
    end
  end
end
