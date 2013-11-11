class RelationshipsController < ApplicationController
  #before_action :signed_in_user

before_action :signed_in_user,
                only: [:create, :destroy, :createStandard]
  # respond_to :html, :js

  # def create
  #   @user = User.find(params[:relationship][:followed_id])
  #   current_user.follow!(@user)
  #   respond_with @user
  # end

  # def destroy
  #   @user = Relationship.find(params[:id]).followed
  #   current_user.unfollow!(@user)
  #   respond_with @user
  # end

  def createStandard
    puts('\n\ncreateStandard\n\n\n\n')
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroyStandard
    puts('destroyStandard')
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    redirect_to @user
  end

  def create
    puts('create')
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    puts('destroy')
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end