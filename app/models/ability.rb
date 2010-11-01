class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, Server
      can :manage, Key, :user_id => user.id
      can :manage, User, :id => user.id
    end
  end
end

