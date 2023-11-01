class RobotsController < ApplicationController
  def robots
    robots = File.read(Rails.root + "config/robots.#{Rails.env}.txt")
    render plain: robots, layout: false
  end
end
