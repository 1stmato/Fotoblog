class PlacesController < ApplicationController
  def new
    @place = Place.new
  end

  def show
    client = Foursquare2::Client.new(:client_id => '4LKJJTLZVTTAN3WMHG5OZEL4YRTJ10C01PUPHNL0TIDJIVS4', :client_secret => 'TBH1Z0XRWO4VRG0U1RH4HUDBNUZRA3E2C1CTMTK0LSJZDRBY')
    @places = client.search_venues(:intent => 'global', :query => params[:id], :v => '20140806')
  end
end
