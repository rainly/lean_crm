class Admin < AbstractUser
  devise :authenticatable, :recoverable, :rememberable
end
