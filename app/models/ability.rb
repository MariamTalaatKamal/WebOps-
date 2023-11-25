# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    user ||= User.new
    can [:create, :index, :show], Post
    can [:update, :destroy], Post, user_id: user.id
  end
end
