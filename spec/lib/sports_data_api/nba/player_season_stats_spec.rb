require 'spec_helper'

describe SportsDataApi::Nba::PlayerSeasonStats, vcr: {
    cassette_name: 'sports_data_api_nba_player_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  context 'results from player season stats fetch' do
    let(:season_stats) do
      SportsDataApi.set_access_level(:nba, 't')
      SportsDataApi.set_key(:nba, api_key(:nba))
      SportsDataApi::Nba.season_stats(2013, 'PST', "583ec825-fb46-11e1-82cb-f4ce4684ea4c")
    end
    subject { season_stats }
    it { should be_an_instance_of(SportsDataApi::Nba::PlayerSeasonStats) }
    its(:year) { should eq 2013 }
    its(:type) { should eq :PST }
    its(:team_id) { should eq "583ec825-fb46-11e1-82cb-f4ce4684ea4c" }
    its(:players) { should have(15).players }
  end
end
