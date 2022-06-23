class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, defaule: false # defaultで管理権限を持たないようにする
  end
end
