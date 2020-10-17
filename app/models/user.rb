class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  enum role: { visitor: 0, admin: 10 }
  enum blog_role: { visitor: 0, editor: 10, admin: 20 }, _prefix: :blog
  enum video_role: { visitor: 0, creator: 10, admin: 20 }, _prefix: :video

  def to_s
    full_name.blank? ? email : full_name
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
