class PlansController < ApplicationController
  before_filter :authenticate
  def show
    @plan = current_user.plan.name
  end
end
