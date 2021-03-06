# encoding: utf-8

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  provider               :string(255)
#  uid                    :string(255)
#  asked_for_email        :boolean
#

class User < ActiveRecord::Base

  # Use built-in rails support for password protection
  has_secure_password

  # Callbacks
  before_create             { generate_token(:auth_token) }
  before_create             :set_default_profile

  # Relationships
  has_many                  :organized_books, :class_name => "Book", :foreign_key => "organizer_id"
  has_and_belongs_to_many   :books
  has_many                  :invitations, :foreign_key => 'invited_id'
  has_one                   :client
  belongs_to                :profile

  # Validations
  validates :name,          :presence => true
  validates :email,         :email_format => { :message => 'Não é um formato válido de e-mail', :allow_blank => true },
                            :uniqueness => true,
                            :presence => true

  #validates :telephone,     :presence => true  do not use this validate this time. collaborator do not need telephone                        
  validates :password,      :presence => true, :on => :create

  # Specify fields that can be accessible through mass assignment
  attr_accessible           :email, :name, :password, :password_confirmation, :asked_for_email, :telephone, :profile, :profile_id

  attr_accessor :book_id

  accepts_nested_attributes_for :profile

  # Other methods
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.password_reset(self).deliver
  end

  def send_book_invitation(inviter, book_uuid)
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(:validate => false)
    UserMailer.book_invitation(inviter, self, book_uuid).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def self.from_omniauth(auth)
    where(auth.slice('provider', 'uid')).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    new_user = new({ :provider => auth['provider'], :uid => auth['uid'], :name => auth['info']['name'], :email => auth['info']['email'] }, :without_protection => true)
    new_user.save!(:validate => false)
    new_user
  end

  def set_default_profile
    self.profile = Profile.first
  end

  def admin?
    self.profile.desc == 'Admin'
  end

  def publisher?
    self.profile.desc == 'Publisher'
  end
end
