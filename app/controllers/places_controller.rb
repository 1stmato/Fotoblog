class PlacesController < ApplicationController
  def new
    @place = Place.new
  end

  def search
    client = Foursquare2::Client.new(:client_id => '4LKJJTLZVTTAN3WMHG5OZEL4YRTJ10C01PUPHNL0TIDJIVS4', :client_secret => 'TBH1Z0XRWO4VRG0U1RH4HUDBNUZRA3E2C1CTMTK0LSJZDRBY')
    venues = client.search_venues(:near => params[:place][:city], :query => params[:place][:name], :radius => '50000', :v => '20140806') rescue nil
    @places = []
    if venues.present?
      venues.each do |place|
        JSON.parse(place[1].to_json).each do |p|
          @places.append([p['name'], [p['id'], p['location']['lat'], p['location']['lng']]]) unless p.is_a?(Array)
        end
      end
    end
  end

  private

  def post_params
    params.require(:place).permit(:name, :city)
  end
end
