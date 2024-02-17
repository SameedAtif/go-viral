ActiveAdmin.register User do
  permit_params :first_name, :last_name, :phone_number, :email

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :phone_number
    column :email

    actions
  end

  filter :first_name
  filter :last_name
  filter :phone_number
  filter :email
end
