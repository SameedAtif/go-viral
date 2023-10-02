class SystemPackagesController < ApplicationController
  # TODO: Too much dynamic creation leads to security vulnerability
  # Suggesion: Only fetch resource_name, property_name, operation_value from the user.
  #            Prices should be stored in the code.
  # TODO: resource restriction
  # TODO: Payment-API Integration
  def create
    ActiveRecord::Base.transaction do
      system_package = SystemPackage.new(permitted_params)
      system_package.gross_price = system_package.system_package_resources.sum do |spr|
        spr.send("#{spr.resource_name}_price", spr.resource_value.to_f)
      end
      system_package.package_name = 'custom',
      system_package.fee = system_package.package_name == 'custom' ? SystemPackage::CUSTOM_PACKAGE_FEE : SystemPackage::BASIC_PACKAGE_FEE
      system_package.package_description = 'You choose what\'s best for you'
      system_package.entity_name = session[:user_role]
      system_package.system_package_resources.each do |spr|
        spr.gross_price = spr.send("#{spr.resource_name}_price", spr.resource_value.to_f)
        spr.fee = SystemPackageResource::BASE_FEE
        spr.category = spr.gross_price > 0 ? SystemPackageResource::CATEGORY_TYPES[:paid] : SystemPackageResource::CATEGORY_TYPES[:free]
      end
      system_package.save!
    end
  end

  private

  def permitted_params
    params.require(:system_package).permit(
      :payment_plan,
      system_package_resources_attributes: %i[
        resource_name resource_value _destroy
      ]
    )
  end
end
