class Ability
  include CanCan::Ability

  def initialize(user)
    if user.admin?
      can :manage, :all
    else
      can :read, Server
      can :read, ServerUser, :user_id => user.id
      can :create, SshKey
      can :manage, SshKey, :user_id => user.id
      can :manage, User, :id => user.id
    end
  end
end

