class CollaboratorPolicy < ApplicationPolicy

  def new?
    #true
    #false
    #user.premium? || user.admin?
    create?
  end

  def create?
    #true
    user.premium? || user.admin?
    #record.user == user
    #false
  end

  def destroy?
    #true
    #false
    create?
    #user.premium? || user.admin?
  end



end
