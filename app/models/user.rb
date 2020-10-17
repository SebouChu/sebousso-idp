class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  enum role: { visitor: 0, admin: 10 }
  enum blog_role: { visitor: 0, editor: 10, admin: 20 }, _prefix: :blog
  enum video_role: { visitor: 0, creator: 10, admin: 20 }, _prefix: :video

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
end
