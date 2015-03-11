require 'spec_helper'

describe SportsDataApi::Nhl::Team, vcr: {
    cassette_name: 'sports_data_api_nhl_team',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:teams) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.teams
  end
  let(:roster) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.team_roster('44151f7a-0f24-11e2-8525-18a905767e44')
  end
  let(:game_summary) do
    SportsDataApi.set_key(:nhl, api_key(:nhl))
    SportsDataApi.set_access_level(:nhl, 't')
    SportsDataApi::Nhl.game_summary('f0f7e327-3a3a-410b-be75-0956c90c4988')
  end

  context 'results from teams fetch' do
    subject { teams.first }
    it { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:id) { should eq "44151f7a-0f24-11e2-8525-18a905767e44" }
    its(:alias) { should eq 'LA' }
    its(:conference) { should eq 'WESTERN' }
    its(:division) { should eq 'PACIFIC' }
    its(:market) { should eq 'Los Angeles' }
    its(:name) { should eq 'Kings' }
    its(:players) { should eq [] }
    its(:points) { should be_nil }
  end
  context 'results from team roster fetch' do
    subject { roster }
    it { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:id) { should eq "44151f7a-0f24-11e2-8525-18a905767e44" }
    its(:alias) { should eq 'LA' }
    its(:market) { should eq 'Los Angeles' }
    its(:name) { should eq 'Kings' }
    its(:players) { should be_an_instance_of(Array) }
    its(:points) { should be_nil }
    context 'players' do
      subject { roster.players }
      its(:count) { should eq 25 }
    end
  end
  context 'results from game_summary fetch' do
    subject { game_summary.home_team }
    it { should be_an_instance_of(SportsDataApi::Nhl::Team) }
    its(:id) { should eq '441713b7-0f24-11e2-8525-18a905767e44' }
    its(:market) { should eq 'Montreal' }
    its(:name) { should eq 'Canadiens' }
    its(:points) { should eq 3 }
    its(:alias) { should be_nil }
    its(:conference) { should be_nil }
    its(:division) { should be_nil }
    its(:players) { should be_an_instance_of(Array) }
    
    context 'players' do
      subject { game_summary.home_team.players }
      its(:count) { should eq 26 }
    end

    context 'player' do
      subject { game_summary.away_team.players.first }
      it { should be_an_instance_of(SportsDataApi::Nhl::Player) }
      it 'should have an id' do
        expect(subject.player[:id]).to eq "42bf409e-0f24-11e2-8525-18a905767e44"
      end
      it 'should have a full_name' do
        expect(subject.player[:full_name]).to eq "Dave Bolland"
      end
      it 'should have a first_name' do
        expect(subject.player[:first_name]).to eq "Dave"
      end
      it 'should have a last_name' do
        expect(subject.player[:last_name]).to eq "Bolland"
      end
      it 'should have a position' do
        expect(subject.player[:position]).to eq "F"
      end
      it 'should have a primary_position' do
        expect(subject.player[:primary_position]).to eq "C"
      end
      it 'should have a jersey_number' do
        expect(subject.player[:jersey_number]).to eq "63"
      end
      it 'should have a played' do
        expect(subject.player[:played]).to eq true
      end
      it 'should not be scratched' do
        expect(subject.player[:scratched]).to eq nil
      end
      it 'should not have goaltending' do
        expect(subject.stats.goaltending).to eql nil
      end

      its(:stats){ should be_an_instance_of(SportsDataApi::Stats) }
    end
  end
end
