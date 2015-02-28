class User < ActiveRecord::Base
  has_secure_password

  has_many :groups
  has_many :feeds

  after_create :add_default_group

  def add_default_group
    Group.create(user_id: id, title: 'Default Group', default: true)
  end
end
