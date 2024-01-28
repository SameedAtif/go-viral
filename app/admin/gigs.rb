ActiveAdmin.register Gig do
  permit_params :title, :reviewed, :status, :targeted_demographic_start_age, :targeted_demographic_end_age,
                :targeted_geographic_audience, :description

  index do
    selectable_column
    id_column
    column :title
    column :reviewed
    column :status
    actions
  end

  filter :title
  filter :reviewed
  filter :status

  form do |f|
    f.inputs do
      f.input :title
      f.input :reviewed
      f.input :status, as: :select, collection: Gig::STATUSES
      f.input :targeted_demographic_start_age
      f.input :targeted_demographic_end_age
      f.input :targeted_geographic_audience
    end
    f.actions
  end
end
