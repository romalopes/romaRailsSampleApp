class UsersController < ApplicationController

  def show
  	# user = User.new(name: "Roma lopes", email: "romalopes@example.com",
   #                   password: "foobar", password_confirmation: "foobar")
  	# user.save
    @user = User.find(params[:id])
    puts @user
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

    private
      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end

end
