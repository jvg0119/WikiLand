class WikiPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    #scope.where(:id => record.id).exists? &&
      record.private == false || # public wiki
      record.private == true && record.user == user || # private wiki owned by current_user
      record.private == true && record.wiki_collaborators.include?(user) || # private & current_user is a collaborator
      record.private == true && (user && user.admin?) # private & current_user is an admin or no user
  end

  def create?
    user.present?
  end

  def update?
    (user.present? && record.private == false) || # the wiki is public
    (user.present? && user.admin?) || #
    (user.present? && record.user == user) || # the wiki owner is the current_user
    (user.present? && record.private == true) && (record.wiki_collaborators.include?(user))
                              # wiki is private & current_user is a collaborator for this wiki
  end

  def destroy?
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
        scope.public_wikis + scope.private_wikis(user) + user.wiki_collaborations
      elsif user.try(:standard?)
        scope.public_wikis + user.wiki_collaborations
        #raise
      else
        scope.public_wikis
      end
    end # resolve

# resole below works
    # def resolve
    #   scope
    #   wikis = []
    #   all_wikis = scope.all
    #   if user.try(:admin?)
    #     all_wikis.each do |wiki|
    #       wikis << wiki
    #     end
    #   elsif user.try(:premium?)
    #     all_wikis.each do |wiki|
    #       if !wiki.private? || wiki.user == user || wiki.wiki_collaborators.include?(user)
    #         wikis << wiki
    #       end
    #     end
    #   else
    #     all_wikis.each do |wiki| # standard & guests
    #       if !wiki.private? || wiki.wiki_collaborators.include?(user)
    #         wikis << wiki
    #       end
    #     end
    #   end # if user.try(:admin?)
    #   wikis
    # end  # resolve

  end # scope

end
