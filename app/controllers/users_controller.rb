class UsersController < ApplicationController

  #before_action :signed_in_user, only: [:edit, :update]
  #before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
   before_action :admin_user,     only: :destroy


  def index
    #@users = User.all
    @users = User.paginate(page: params[:page])
  end

  def show
  	# user = User.new(name: "Roma lopes", email: "romalopes@example.com",
   #                   password: "foobar", password_confirmation: "foobar")
  	# user.save
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
	    @user = User.new
  end

  def create
    #@user = User.new(params[:user])    # Not the final implementation!
    # is equivalent to 
    #@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")
    @user = User.new(user_params)
    if @user.save
      # Handle a successful save.
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Handle a successful update.
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

     # Before filters
     #Moved to sessions_helper.rb
    # def signed_in_user
    #   #redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #   unless signed_in?
    #     store_location
    #     redirect_to signin_url, notice: "Please sign in."
    #   end

      #Equivalent to 
      # unless signed_in?
      #   flash[:notice] = "Please sign in."
      #   redirect_to signin_url
      # end
   # end

     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

     def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
