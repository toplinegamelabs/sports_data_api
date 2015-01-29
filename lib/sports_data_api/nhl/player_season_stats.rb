module SportsDataApi
  module Nhl
    class PlayerSeasonStats
      attr_reader :team_id, :year, :type, :players

      def initialize(xml)
        if xml.is_a? Nokogiri::XML::NodeSet
          @year = xml.first["year"].to_i
          @type = xml.first["type"].to_sym
          @team_id = xml.first.xpath('team').first['id']
          @players = xml.first.xpath('team/player_records/player').map do |player_xml|
            Player.new(player_xml)
          end
        end
      end
    end
  end
end
