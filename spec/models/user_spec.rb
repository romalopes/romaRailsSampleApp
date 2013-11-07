require 'spec_helper'

describe User do


  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

	# before { @user = User.new(name: "Example User", email: "user@example.com") }

	# subject { @user }  # for the variable user

	# it { should respond_to(:name) }  # verify if these attributes exists
	# it { should respond_to(:email) }
	# it { should be_valid }
	# it { should respond_to(:password_digest) }

	describe "when password is not present" do
	  before do
	    @user = User.new(name: "Example User", email: "user@example.com",
	                     password: " ", password_confirmation: " ")
	  end
	  it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }
	  it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end


	describe "return value of authenticate method" do
		#Before the test sava the user created previously
		before { @user.save }
		#user found_user is retrieved from DB
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			# It will authenticate found_user == @user.
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			#It may return false
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not eq user_for_invalid_password }
			#It will NOT authenticate
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

	it "should be valid" do
  		expect(@user).to be_valid
	end

	it "should respond to 'name'" do
		expect(@user).to respond_to(:name)
	end

	describe "when name is not present" do
	    before { @user.name = "" }
	    it { should_not be_valid }
	end

	describe "when name is too long" do
	    before { @user.name = "a" * 51 }
	    it { should_not be_valid }
  	end

	 describe "when email format is invalid" do
	    it "should be invalid" do
	      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
	                     foo@bar_baz.com foo@bar+baz.com foo@barbaz..com]
	      addresses.each do |invalid_address|
	        @user.email = invalid_address
	        expect(@user).not_to be_valid
	      end
	    end
	  end

	  describe "when email format is valid" do
	    it "should be valid" do
	      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	      addresses.each do |valid_address|
	        @user.email = valid_address
	        expect(@user).to be_valid
	      end
	    end
	  end

	 describe "when email address is already taken" do
	    before do
	      user_with_same_email = @user.dup
	      user_with_same_email.save
	    end

	    it { should_not be_valid }
	end

	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

		it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			expect(@user.reload.email).to eq mixed_case_email.downcase
		end
	end


end

# describe User do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
