require 'spec_helper'

describe SportsDataApi::Nba::Team, vcr: {
    cassette_name: 'sports_data_api_nba_team',
    record: :new_episodes,
    match_requests_on: [:host, :path]
} do
  let(:teams) do
    SportsDataApi.set_key(:nba, api_key(:nba))
    SportsDataApi.set_access_level(:nba, 't')
    SportsDataApi::Nba.teams
  end
  let(:roster) do
    SportsDataApi.set_key(:nba, api_key(:nba))
    SportsDataApi.set_access_level(:nba, 't')
    SportsDataApi::Nba.team_roster('583ec825-fb46-11e1-82cb-f4ce4684ea4c')
  end
  let(:game_summary) do
    SportsDataApi.set_key(:nba, api_key(:nba))
    SportsDataApi.set_access_level(:nba, 't')
    SportsDataApi::Nba.game_summary('e1dcf692-330d-46d3-8add-a241b388fbe2')
  end

  context 'results from teams fetch' do
    subject { teams.first }
    it { should be_an_instance_of(SportsDataApi::Nba::Team) }
    its(:id) { should eq "583ec8d4-fb46-11e1-82cb-f4ce4684ea4c" }
    its(:alias) { should eq 'WAS' }
    its(:conference) { should eq 'EASTERN' }
    its(:division) { should eq 'SOUTHEAST' }
    its(:market) { should eq 'Washington' }
    its(:name) { should eq 'Wizards' }
    its(:players) { should eq [] }
    its(:points) { should be_nil }
  end
  context 'results from team roster fetch' do
    subject { roster }
    it { should be_an_instance_of(SportsDataApi::Nba::Team) }
    its(:id) { should eq "583ec825-fb46-11e1-82cb-f4ce4684ea4c" }
    its(:alias) { should eq 'GSW' }
    its(:market) { should eq 'Golden State' }
    its(:name) { should eq 'Warriors' }
    its(:players) { should be_an_instance_of(Array) }
    its(:points) { should be_nil }
    context 'players' do
      subject { roster.players }
      its(:count) { should eq 15 }
    end
  end
  context 'results from game_summary fetch' do
    subject { game_summary.home_team }
    it { should be_an_instance_of(SportsDataApi::Nba::Team) }
    its(:id) { should eq '583ec825-fb46-11e1-82cb-f4ce4684ea4c' }
    its(:market) { should eq 'Golden State' }
    its(:name) { should eq 'Warriors' }
    its(:points) { should eq 125 }
    its(:alias) { should be_nil }
    its(:conference) { should be_nil }
    its(:division) { should be_nil }
    its(:players) { should be_an_instance_of(Array) }
    
    context 'players' do
      subject { game_summary.home_team.players }
      its(:count) { should eq 14 }
    end

    context 'player' do
      subject { game_summary.home_team.players.first }
      it { should be_an_instance_of(SportsDataApi::Nba::Player) }
      it 'should have an id' do
        expect(subject.player[:id]).to eq "e4bd8c65-a40b-42e3-8327-6913045bf008"
      end
      it 'should have a full_name' do
        expect(subject.player[:full_name]).to eq "Marreese Speights"
      end
      it 'should have a first_name' do
        expect(subject.player[:first_name]).to eq "Marreese"
      end
      it 'should have a last_name' do
        expect(subject.player[:last_name]).to eq "Speights"
      end
      it 'should have a position' do
        expect(subject.player[:position]).to eq "F-C"
      end
      it 'should have a primary_position' do
        expect(subject.player[:primary_position]).to eq "PF"
      end
      it 'should have a jersey_number' do
        expect(subject.player[:jersey_number]).to eq "5"
      end
      it 'should have a played' do
        expect(subject.player[:played]).to eq true
      end
      it 'should have an active' do
        expect(subject.player[:active]).to eq true
      end
      its(:stats){ should be_an_instance_of(SportsDataApi::Stats) }

      context 'stats' do
        subject { game_summary.home_team.players.first.stats.statistics }
        it 'should have minutes' do
          expect(subject[:minutes]).to eql '19:45'
        end
        it 'should have field_goals_made' do
          expect(subject[:field_goals_made]).to eql 2
        end
        it 'should have field_goals_made' do
          expect(subject[:field_goals_att]).to eql 10
        end
        it 'should have field_goals_pct' do
          expect(subject[:field_goals_pct]).to eql 20.0
        end
        it 'should have two_points_made' do
          expect(subject[:two_points_made]).to eql 1
        end
        it 'should have two_points_att' do
          expect(subject[:two_points_att]).to eql 8
        end
        it 'should have two_points_pct' do
          expect(subject[:two_points_pct]).to eql 0.125
        end
        it 'should have three_points_made' do
          expect(subject[:three_points_made]).to eql 1
        end
        it 'should have three_points_att' do
          expect(subject[:three_points_att]).to eql 2
        end
        it 'should have three_points_pct' do
          expect(subject[:three_points_pct]).to eql 50.0
        end
        it 'should have blocked_att' do
          expect(subject[:blocked_att]).to eql 2
        end
        it 'should have free_throws_made' do
          expect(subject[:free_throws_made]).to eql 2
        end
        it 'should have free_throws_att' do
          expect(subject[:free_throws_att]).to eql 2
        end
        it 'should have free_throws_pct' do
          expect(subject[:free_throws_pct]).to eql 100.0
        end
        it 'should have offensive_rebounds' do
          expect(subject[:offensive_rebounds]).to eql 1
        end
        it 'should have defensive_rebounds' do
          expect(subject[:defensive_rebounds]).to eql 7
        end
        it 'should have rebounds' do
          expect(subject[:rebounds]).to eql 8
        end
        it 'should have assists' do
          expect(subject[:assists]).to eql 3
        end
        it 'should have turnovers' do
          expect(subject[:turnovers]).to eql 0
        end
        it 'should have steals' do
          expect(subject[:steals]).to eql 1
        end
        it 'should have blocks' do
          expect(subject[:blocks]).to eql 0
        end
        it 'should have assists_turnover_ratio' do
          expect(subject[:assists_turnover_ratio]).to eql 0
        end
        it 'should have personal_fouls' do
          expect(subject[:personal_fouls]).to eql 2
        end
        it 'should have tech_fouls' do
          expect(subject[:tech_fouls]).to eql 0
        end
        it 'should have flagrant_fouls' do
          expect(subject[:flagrant_fouls]).to eql 0
        end
        it 'should have pls_min' do
          expect(subject[:pls_min]).to eql 3
        end
        it 'should have points' do
          expect(subject[:points]).to eql 7
        end
      end
    end
  end
end
