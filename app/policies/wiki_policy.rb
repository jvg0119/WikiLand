class WikiPolicy < ApplicationPolicy

  def index?
    # false
    true
  end

  def show?
    #scope.where(:id => record.id).exists?
    true
  end

  def create?
    # false
    user.present?
  end

  def update?
    # false
    user.present?
  end

  def destroy?
    # false
    user.present? && (record.user == user || user.admin?)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.try(:admin?)
        scope.all
      elsif user.try(:premium?)
        scope.public_wikis + scope.private_wikis.where(user: user)
      else
        scope.public_wikis
      end
    end
  end

end
