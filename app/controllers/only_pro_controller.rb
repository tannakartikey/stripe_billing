class OnlyProController < ApplicationController
  before_filter :authorize, only: [:pro]
  def pro
  end
end
