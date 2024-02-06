ActiveAdmin.register Influencer do
  permit_params :reviewed

  index do
    selectable_column
    id_column
    column :reviewed
    actions
  end

  filter :reviewed

  form do |f|
    f.inputs do
      f.input :reviewed
    end
    f.actions
  end
end
