class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  enum role: { visitor: 0, admin: 10 }
  enum blog_role: { visitor: 0, editor: 10, admin: 20 }, _prefix: :blog
  enum video_role: { visitor: 0, creator: 10, admin: 20 }, _prefix: :video

  validates_presence_of :email
  validates_uniqueness_of :email, allow_blank: true, if: :will_save_change_to_email?
  validates_format_of :email, with: Devise::email_regexp, allow_blank: true, if: :will_save_change_to_email?
  validates_presence_of :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?
  validate :password_complexity

  before_validation :generate_uid, on: :create

  def to_s
    full_name.blank? ? email : full_name
  end

  def to_param
    uid
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  protected

  def generate_uid
    loop do
      self.uid = random_uid
      break unless uid_exists?(uid)
    end
  end

  # 1 099 511 627 776 possibilities
  def random_uid
    SecureRandom.hex 5
  end

  def uid_exists?(uid)
    self.class.unscoped.where(uid: uid).exists?
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!,@$%^&*\-+£µ]).{8,70}$/
    errors.add :password, 'complexity requirement not met. Length should be 8-70 characters and include: 1 uppercase, 1 lowercase, 1 digit and 1 special character'
  end
end
