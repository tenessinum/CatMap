class PointController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: %i[extract]


  def create
    @point = Point.create(
      :title => params[:title],
      :description => params[:description],
      :lat => params[:lat].to_f,
      :lon => params[:lon].to_f,
      :finder => current_user.email
    )
  end

  def remove
    @point = Point.find(params[:point_id].to_i)
    if @point.finder == current_user.email then @point.destroy end
    redirect_to root_path
  end

  def extract
    lat = params[:lat].to_f
    lon = params[:lon].to_f
    radius = params[:radius].to_f

    @selected_points = Point.select{ |point| in_radius?(point, lat, lon, radius) }

    respond_to do |format|
      format.html { render "extract", :layout => false }
      format.json { render json: @selected_points }
    end
  end

  private

  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180
    rkm = 6371
    rm = rkm * 1000
    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
  
    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }
  
    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
  
    rm * c
  end

  def in_radius?(point, lat, lon, radius)
    distance([point[:lat], point[:lon]], [lat, lon]) < radius * 1000
  end
end
