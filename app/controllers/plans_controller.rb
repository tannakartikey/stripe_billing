class PlansController < ApplicationController
  def show
    @plan = current_user.plan.name
  end
end
