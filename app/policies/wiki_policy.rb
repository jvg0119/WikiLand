class WikiPolicy < ApplicationPolicy

  def index?
    # false
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
      scope.all
    end
  end

end
