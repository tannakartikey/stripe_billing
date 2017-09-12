class MyAccountController < ApplicationController
  before_filter :authorize, only: [:pro]
  def index
  end
  def pro
  end
end
