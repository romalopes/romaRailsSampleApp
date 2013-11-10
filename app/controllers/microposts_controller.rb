class MicropostsController < ApplicationController
  #signed_in_user is in sessions_helper.rb
  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end
  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # current_user is in sessions_helper.rb
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
    #OR using exceptions.
    def correct_user_other_similar_to_above
      @micropost = current_user.microposts.find(params[:id])
    rescue
      redirect_to root_url
    end
end