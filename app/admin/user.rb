ActiveAdmin.register User do
  permit_params(
    :store_name,
    :phone_number,
    :image,
    :delivery_info,
    :email,
    # only on a very specific and verified case
    # you should change this param otherwise is dangerous.
    # :store_account,
    :user_token
  )

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
