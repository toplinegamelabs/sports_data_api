require 'spec_helper'

describe SportsDataApi::Nhl::PlayerSeasonStats, vcr: {
    cassette_name: 'sports_data_api_nhl_player_season_stats',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  context 'results from player season stats fetch' do
    let(:season_stats) do
      SportsDataApi.set_access_level(:nhl, 't')
      SportsDataApi.set_key(:nhl, api_key(:nhl))
      SportsDataApi::Nhl.season_stats(2013, 'REG', "4417b7d7-0f24-11e2-8525-18a905767e44")
    end
    subject { season_stats }
    it { should be_an_instance_of(SportsDataApi::Nhl::PlayerSeasonStats) }
    its(:year) { should eq 2013 }
    its(:type) { should eq :REG }
    its(:team_id) { should eq "4417b7d7-0f24-11e2-8525-18a905767e44" }
    its(:players) { should have(40).players }
  end
end
