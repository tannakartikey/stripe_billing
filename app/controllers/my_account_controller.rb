class MyAccountController < ApplicationController
  before_filter :authenticate, only: [:index]
  before_filter :authorize, only: [:pro]
  def index
  end
  def pro
  end
end
