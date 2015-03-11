module SportsDataApi
  module Nba
    class Venue
      attr_reader :id, :name, :address, :city, :state, :zip, :country, :capacity
      def initialize(venue)
        if venue
          @id = venue['id']
          @name = venue['name']
          @address = venue['address']
          @city = venue['city']
          @state = venue['state']
          @zip = venue['zip']
          @country = venue['country']
          @capacity = venue['capacity']
        end
      end
    end
  end
end
