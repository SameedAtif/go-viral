class AddressesController < ApplicationController
  skip_before_action :authenticate_user!, only: :fetch_states

  def fetch_states
    country_code = params[:country_codes].uniq
    countries = country_code.map { |code| ISO3166::Country[code] }
    states = countries.map do |country|
      { text: country.unofficial_names.first, id: country.alpha2, children: country.states.values.map { |s| {id: s.code, text: s.name } } }
    end

    render json: states
  end
end
