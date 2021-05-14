class RelationshipsController < ApplicationController
  before_action :authorize_request

  def index
    @current_user
  end

  def create
  end

  def destroy
  end
end
