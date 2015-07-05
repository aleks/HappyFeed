class User < ActiveRecord::Base
  has_secure_password

  validates :email, uniqueness: true
  validate :validate_email

  has_many :groups
  has_many :feeds

  after_create :add_default_group

  private

    def add_default_group
      Group.create(user_id: id, title: 'Default Group', default: true)
    end

    def validate_email
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
        errors.add(:email, "is not a valid email address!")
      end
    end

end
