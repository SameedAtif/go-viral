ActiveAdmin.register GigDispute do
  permit_params :status, :resolved_in_favor

  index do
    selectable_column
    id_column
    column :status
    column :resolved_in_favor
    actions
  end

  filter :status
  filter :resolved_in_favor

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: GigDispute::STATUS_TYPES
      f.input :resolved_in_favor, as: :select, collection: GigDispute::RESOURCE_TYPES
    end
    f.actions
  end
end
