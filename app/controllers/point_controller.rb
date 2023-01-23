# frozen_string_literal: true

# Point controller
class PointController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!, only: %i[extract]

  def create
    @point = Point.create(
      title: params[:title],
      description: params[:description],
      lat: params[:lat].to_f,
      lon: params[:lon].to_f,
      finder: current_user.email
    )
  end

  def remove
    @point = Point.find(params[:point_id].to_i)
    @point.destroy if @point.finder == current_user.email
    redirect_to root_path
  end

  def extract
    radius = params[:radius].to_f

    @selected_points = Point.select { |point| in_radius?(point, params[:lat].to_f, params[:lon].to_f, radius) }

    respond_to do |format|
      format.html { render 'extract', layout: false }
      format.json { render json: @selected_points }
    end
  end

  private

  def prepeare_angles(loc1, loc2)
    rad_per_deg = Math::PI / 180
    dlat_rad = (loc2[0] - loc1[0]) * rad_per_deg / 2
    dlon_rad = (loc2[1] - loc1[1]) * rad_per_deg / 2

    lat1_rad = loc1[0] * rad_per_deg
    lat2_rad = loc2[0] * rad_per_deg

    [dlat_rad, dlon_rad, lat1_rad, lat2_rad]
  end

  def distance(loc1, loc2)
    a, b, c, d = prepeare_angles(loc1, loc2)

    e = Math.sin(a)**2 + Math.cos(c) * Math.cos(d) * Math.sin(b)**2
    c = Math.atan2(Math.sqrt(e), Math.sqrt(1 - e))

    12_742_000 * c
  end

  def in_radius?(point, lat, lon, radius)
    distance([point[:lat], point[:lon]], [lat, lon]) < radius * 1000
  end
end
