class PasswordDigest < ActiveRecord::Migration
  def change
    add_column :players, :password_digest, :string
    remove_column :players, :password, :string
  end
end
