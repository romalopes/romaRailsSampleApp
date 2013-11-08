Sample application using Rails
==============================

# Ruby on Rails Tutorial: sample application

This is the sample application for
the [*Ruby on Rails Tutorial*](http://railstutorial.org/)
by [Michael Hartl](http://michaelhartl.com/).

########A new application
		http://ruby.railstutorial.org
		- Create a project without tests
		$ rails new romaRailsSampleApp --skip-test-unit
	- Change gemFile
		To include capybara and create environments
	- Run bundle
		$ bundle install --without production
		$ bundle update
		$ bundle install
	- Change config/initializer/secret_token.rb
		 secret token used by Rails to encrypt session variables so that it is dynamically generated rather than hard-coded
		- Configure Rails to user RSpec in place of Test:Unit
			$ rails generate rspec:install
	- Run git and heroku
		As I already know.
		- git checkout -b static-pages
			To create a branch for this modifications
	- Creating static pages
		As every page has to pass through controllers, it is needed to create generate a controller
		$ rails generate controller StaticPages home help --no-test-framework
		- Create home and help, without tests infra-structure(RSpec)
			Create many files(static_pages_controller, home.htlm.erb, static_pages_helper.rb, static_pages.js.coffee, static_pages.css.scss)
			Add home and help to routes.rb
	- If I want to remove a Controoler or Model
		$ rails generate controller FooBars baz quux
  		$ rails destroy  controller FooBars baz quux
  		
  		$ rails generate model Foo bar:string baz:integer
		$ rails destroy model Foo
		
		$ rake db:migrate
		$ rake db:rollback
		$ rake db:migrate VERSION=0 # Go to begin
	- Testing
		Introductions
			- RSpec uses BDD while Test::Unit uses TDD
			- To learn more: https://www.codeschool.com/courses/testing-with-rspec
			- Capybara provide a natural-language syntax to integrate the tests.
			- Cucumber can be used tool
		Step 1. write the failing test
			$ rails generate integration_test static_pages
				Will create spec/requests/static_pages_spec.rb
			The code is a bit different from traditional Ruby due to DSL.
			ex:
			describe "Home page" do
			    it "should have the content 'Sample App'" do
			      	#visit '/static_pages/home'
			    	#visit '/home'
	    			visit home_path
			      expect(page).to have_content('Sample App')
			    end
			  end
			end

			OR
			  subject { page }   # use the "expect(page).to "

			  describe "Home page" do
			    before { visit root_path }  # avoit the visit in each call

			    it { should have_content('Sample App') }
			    it { should have_title("Ruby on Rails Tutorial Sample App") }
			    it { should have_title(full_title('')) }
			    it { should_not have_title('| Home') }
			  end

			  describe "Contact page" do
			    before { visit contact_path }

			    it { should have_content('Contact') }
			    it { should have_selector('h1', text: 'Contact') }
			    it { should have_title(full_title('Contact')) }
			  end

			- full_title...  is a method created in spec/suport/utilities.rb
			  Identical to the methods created in helpers/application_helper.rb, which is used but the application

				def full_title(page_title)
				  base_title = "Ruby on Rails Tutorial Sample App"
				  if page_title.empty?
				    base_title
				  else
				    "#{base_title} | #{page_title}"
				  end
				end

				Later change utilities.br to:
				include ApplicationHelper

				and create a files spec/helper/application_helper_spec.rb
					require 'spec_helper'

					describe ApplicationHelper do

					  describe "full_title" do
					    it "should include the page title" do
					      expect(full_title("foo")).to match(/foo/)
					    end

					    it "should include the base title" do
					      expect(full_title("foo")).to match(/^Ruby on Rails Tutorial Sample App/)
					    end

					    it "should not include a bar for the home page" do
					      expect(full_title("")).not_to match(/\|/)
					    end
					  end
					end



			Reference for test:
			    it { should have_content('Contact') }
			    it { should have_selector('h1', text: 'Contact') }
			    it { should have_title(full_title('Contact')) }
			    it { should_not have_title(full_title('Contact')) }
 				click_link "About" expect(page).to have_title(full_title('About Us'))
			change config/routes.rb
			From
				get "static_pages/contact"
				get "static_pages/home"
				get "static_pages/help"
				get "static_pages/about"
			To
				root  'static_pages#home'
				match '/',		  to: 'static_pages#home',    via: 'get'
				match '/home',    to: 'static_pages#home',    via: 'get'
				match '/help',    to: 'static_pages#help',    via: 'get'
				match '/about',   to: 'static_pages#about',   via: 'get'
				match '/contact', to: 'static_pages#contact', via: 'get'
			These changes will allow pages to be accesses directly: /home instead of static_pages/rome.
			
			about_path -> '/about'
			about_url  -> 'http://localhost:3000/about'

		Step 2 Include the capybara in spec_helper.rb
			 config.include Capybara::DSL
		Step 3. Running the test
			$ bundle exec rspec spec/requests/static_pages_spec.rb
				It will fail at first.
			- Just include
				<h1>Sample App</h1>
				It will run because the test expects it.
		- Test with GUARD - https://github.com/guard/guard
			- Automate unit test
		- Speeding up tests with Spork - https://github.com/sporkrb/spork
			Everytime we run $ exec rspec, it is reloaded 

			Run again: bundle exec guard


		- Test and Rails inside Sublime
			https://github.com/maltize/sublime-text-2-ruby-tests
			Command-Shift-R: run a single test (if run on an it block) or group of tests (if run on a describe block)
			Command-Shift-E: run the last test(s)
			Command-Shift-T: run all the tests in current file

	- Adding a page already using tests
		In static_pages_spec.rb
			describe "About page" do
				it "should have the content 'About Us'" do
				  visit '/static_pages/about'
				  expect(page).to have_content('About Us')
				end
			end
		- Run the test and it will fail
			$ bundle exec rspec spec/requests/static_pages_spec.rb
		- Add the about page in config/routes.rb
			 get "static_pages/about"
		- Add the method in static_pages_controller
			 def about
  			end
  	- layout 
  		app/views/layouts/application.html.erb it used but all pages.

  			Include:
  			 	<%= yield(:title) %>	<--- Insert title
  				<%= yield %>			<--- Insert content

  			Ex:
		  		<% provide(:title, 'Home') %>
				<!DOCTYPE html>
				<html>
				  <head>
				    <title>Ruby on Rails Tutorial Sample App | <%= yield(:title) %></title>
				  </head>
				  <body>
				    <h1>Sample App</h1>
				    <p>
				      This is the home page for the
				      <a href="http://railstutorial.org/">Ruby on Rails Tutorial</a>
				      sample application.
				    </p>
				  </body>
				</html>

Important elements of Ruby that are used in Rails
	About views/layouts/application.html.erb
		<%= stylesheet_link_tag "application", media: "all",
                                       "data-turbolinks-track" => true %>
        Four Ruby ideas:
       	1- built-in Rails Method
       	2- Method invocation without parenteses
       	3- Symbols
       	4- Hash

Filling in the Layout
	First step
		- Change layouts/application.html.erb
		- The image:
			<%= link_to image_tag("rails.png", alt: "Rails"), 'http://rubyonrails.org/' %>
			It is put in app/assets/image
		- run http://localhost:3000/static_pages/home
	Bootstrap
		To add bootstrap to project
			include in gemFile	
				---> gem 'bootstrap-sass', '2.3.2.0' 
				and
				$ bundle install
			In  config/application.rb
				include -> config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
			Create app/assets/stylesheets/custom.css.scss
				and include : 
					@import "bootstrap";
						this include the entire Bootstrap CSS framework.
				This file contrains universal css definitions.
	Partial	
		Inside a html.  Used to call another part of html.
		<%= render 'layouts/header' %>
		Calls app/view/layouts/_header.html.erb

	Asset pipeline - http://guides.rubyonrails.org/asset_pipeline.html
		Files in these directories are automaticaly read via request.
		app/assets: assets specific to the present application
		lib/assets: assets for libraries written by your dev team
vendor/assets: assets from third-party vendors
		- In app/assets/stylesheets/application.css we have
			*= require_self
				
 			*= require_tree .
 				Ensure that all files in app/assets/stylesheets directory will be read to the application as CSS
	Sass (Syntactically awesome stylesheets)
		Accept a .scss file, which is a superset of CSS.
		Very similar to LESS(Windows)
		Ex:
		- FROM
			.center {
			  text-align: center;
			}

			.center h1 {
			  margin-bottom: 10px;
			}
		- TO
			.center {
			  text-align: center;
			  h1 {
			    margin-bottom: 10px;
			  }
			}
	Using link
		<%= link_to "About", '#' %>
		to
		<%= link_to "About", about_path %>

	User Signup
		Create a controler
			$ rails generate controller Users new --no-test-framework
			//Will create the "new" method and its files automaticaly.
		Create the integration test to test the inexisting URL
			$ rails generate integration_test user_pages
			create the file spec/request/user_pages_spec.rb

			require 'spec_helper'
			describe "User pages" do
			  subject { page }

			  describe "signup page" do
			    before { visit signup_path }

			    it { should have_content('Sign up') }
			    it { should have_title(full_title('Sign up')) }
			  end
			end


			RUN: $ bundle exec rspec spec/
			OR
				$ bundle exec rake spec

		Change home to have reference to signup page
		 <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
    Commit and push this verson
	    git add .
		$ git commit -m "Finish layout and routes"
		$ git checkout master
		$ git merge filling-in-layout
		$ git push
		$ git push heroku
		$ heroku open
		$ heroku logs


Modeling Users
	Git
		$ git checkout master
		$ git checkout -b modeling-users
	Generate the controler class and file for User
		$ rails generate controller Users new --no-test-framework
	Generate the model class and file for User
		$ rails generate model User name:string email:string
		- For Model User is singular, different from Controller where Users is plural.

		It create a file for Migration in db/migration/xxxTIME_STAMPxx_create_user.rb
			This file is used to create tables for database.
			class CreateUsers < ActiveRecord::Migration
			  def change
			    create_table :users do |t|
			      t.string :name
			      t.string :email

			      t.timestamps
			    end
			  end
			end

		- Run the migration to DB
			$ bundle exec rake db:migrate
				Creates the file: db/development.sqlite3
			A DB tet is create in db/test.sqlite3, but if there is a problem, create a new DB test.
				$ bundle exec rake test:prepare 
			

		- To reverse the migration if necessary
			$ bundle exec rake db:rollback
		- At this point class User in app/models/user.rb don't have attributes yet.
			class User < ActiveRecord::Base
			end
	Working with model to use in DB
		$ rails console --sandbox
		user = User.new(name: "Michael Hartl", email: "mhartl@example.com")user.save
		user
		user.name 
		User.find(1)
		User.find_by_email("mhartl@example.com")
		User.all
		user.name = 'Anderson Lopes' ----> user.save  #Update one attribute
		user.reload.email # Reloads the value from DB.
		user.created_at 	or 		user.updated_at
		user.update_attributes(name: "The Dude", email: "dude@abides.org")

		foo = User.create(name: "Foo", email: "foo@bar.com")
		foo.destroy
		foo  # The object was removed from DB, but still remains in DB.
	Validation
		Create a testS in spec/models/user.rb
		Test if the attributes exist
			describe User do
				before { @user = User.new(name: "Example User", email: "user@example.com") }
				subject { @user }   # for the variable user
				it { should respond_to(:name) }  # verify if these attributes exists
				it { should respond_to(:email) }

				OR
				it "should respond to 'name'" do
	  				expect(@user).to respond_to(:name)
	  			end

				it { should be_valid }  <---- Verify if it has all attributes

				describe "when name is not present" do
				    before { @user.name = "" }
				    it { should_not be_valid }
				end

			end
		Validate 
			Verify if an attribute is present
			in app/models/user.rb
				class User < ActiveRecord::Base
					before_save { self.email = email.downcase }
					validates :name, presence: true, length: { maximum: 50 }
					VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
					validates :email, presence:   true,
					                format:     { with: VALID_EMAIL_REGEX },
					                uniqueness: { case_sensitive: false }
					validates :password, length: { minimum: 6 }

					has_secure_password
				end


			But to guarantee uniqueness Create an index for users.email.
				$ rails generate migration add_index_to_users_email			
				
				- And change db/migrate/xxxx_add_index...
				class AddIndexToUsersEmail < ActiveRecord::Migration
				  def change
				    add_index :users, :email, unique: true
				  end
				end
				$ bundle exec rake db:migrate
				- And finally in app/model/user.rb
					class User < ActiveRecord::Base
  						before_save { self.email = email.downcase }
					  .
					  .
					  .
					end
 				- $ bundle exec rake test:prepare 
 				- $ bundle exec rspec spec/models/user_spec.rb
 	Add Password and security
 		https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
 		Rails method called has_secure_password  (Rails 3.1)
 		- Include in gemFile
 			gem 'bcrypt-ruby', '3.1.2'
		$ bundle install
		Include test
			  it { should respond_to(:password_digest) }
		- Test will fail
		- Generate migration
			$ rails generate migration add_password_digest_to_users password_digest:string
			- add_password_digest_to_users can be any name, but the sufix "_to_users" refers to users table.
			- name and type of attribute I created(password_digest:string)
		- in db/migrate/[ts]_add_password_digest_to_users.rb it is created
			class AddPasswordDigestToUsers < ActiveRecord::Migration
			  def change
			    add_column :users, :password_digest, :string
			  end
			end
		- Migrate and test
			$ bundle exec rake db:migrate
			$ bundle exec rake test:prepare
			$ bundle exec rspec spec/

	Testing password

		In user_spec.rb
			before do
		    @user = User.new(name: "Example User", email: "user@example.com",
		                     password: "foobar", password_confirmation: "foobar")
			end		
			...
	  		it { should respond_to(:password) }
  			it { should respond_to(:password_confirmation) }
  			-And other tests like blank value.
  		In user.rb "has_secure_password" is enough to work with password.
	  		class User < ActiveRecord::Base
			  .
			  has_secure_password
			end
	User Authentication
		Method to retrieve the User based on email and password.
		Everythin depends on "has_secure_password"
		Two steps:
			1 - Find User based on email
				user = User.find_by(email: email)
			2 - Authenticate with a given password
				current_user = user.authenticate(password)
				- Or return the user object OR false
		Test
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
					#specify is synonym of it. Just used to avoid repetition.
				end
			end		
			- "let" is similar to set a variable.
	GIT
		$ git add .
		$ git commit -m "Make a basic User model (including secure passwords)
		"
		$ git checkout master
		$ git merge modeling-users
		$ git push
		$ git push heroku
		$ heroku open
		$ heroku logs
Sign Up
	$ git checkout master
	$ git checkout -b sign-up
	- Adding debug information
		app/views/layouts/application.html.erb
		<body>
		    <%= render 'layouts/header' %>
		    <div class="container">
		      <%= yield %>
		      <%= render 'layouts/footer' %>
		      <%= debug(params) if Rails.env.development? %>
		    </div>
		</body>
		AND  in custom.css.scss.  Just to show in a good shape

		/*  To debug */
		@mixin box_sizing {
		  -moz-box-sizing: border-box;
		  -webkit-box-sizing: border-box;
		  box-sizing: border-box;
		}

		/* miscellaneous */
		.debug_dump {
		  clear: both;
		  float: left;
		  width: 100%;
		  margin-top: 45px;
		  @include box_sizing;
		}
	Include Resources
		in config/routes.rb:
			resources :users
		- This adds the URL working /users/1 and all RESTs urls
	Create HTML
		app/views/users/show.html.erb
		<%= @user.name %>, <%= @user.email %>
	In controller, creates the method show to return the User.
		class UsersController < ApplicationController

  		def show
    		@user = User.find(params[:id])
  		end
  		...
  	In gemfile . This include the possibility of bootstrap MOCK.
		  gem 'factory_girl_rails', '4.2.1'

	- Then create a file spec/factories.rb
	  	FactoryGirl.define do
		  factory :user do
		    name     "Andersno Lopes"
		    email    "romalopes@yahoo.com.br"
		    password "foobar"
		    password_confirmation "foobar"
		  end
		end
	And use in user_pages_spec.rb test:
		let(:user) { FactoryGirl.create(:user) } 

	  describe "profile page" do
	    let(:user) { FactoryGirl.create(:user) }
	    before { visit user_path(user) }

	    it { should have_content(user.name) }
	    it { should have_title(user.name) }
	  end
	To make test fast with password, goes to config/environment/test.rb and include
		# Speed up tests by lowering bcrypt's cost function.
  		ActiveModel::SecurePassword.min_cost = true

  	Globally recognized avatar ( Gravatar) - http://en.gravatar.com/
  		Free service to upload images and associate with email.
  		In app/views/users/show.html.erb
		<% provide(:title, @user.name) %>
		<div class="row">
		  <aside class="span4">
		    <section>
		      <h1>
		        <%= gravatar_for @user %>
		        <%= @user.name %>
		      </h1>
		    </section>
		  </aside>
		</div>
	In app/helpers/users_helper.rb create the method to be used in show.html.erb.  Similar to taglib.
		module UsersHelper

		  # Returns the Gravatar (http://gravatar.com/) for the given user.
		  def gravatar_for(user)
		    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		    image_tag(gravatar_url, alt: user.name, class: "gravatar")
		  end
		end
	To clean DataBase
		$ bundle exec rake db:reset
		$ bundle exec rake test:prepare
	Tests to sign up page in rspec/requests/user_pages_sspec.rb
		describe "signup" do

		    before { visit signup_path }

		    let(:submit) { "Create my account" }

		    describe "with invalid information" do
		      it "should not create a user" do
		        expect { click_button submit }.not_to change(User, :count)
		      end
		    end

		    describe "with valid information" do
		      before do
		        fill_in "Name",         with: "Example User"
		        fill_in "Email",        with: "user@example.com"
		        fill_in "Password",     with: "foobar"
		        fill_in "Confirmation", with: "foobar"
		      end

		      it "should create a user" do
		        expect { click_button submit }.to change(User, :count).by(1)
		      end
		    end
		end
		- The test will fail because it doesn't change anything yet.
	Using the FORM ---->  Using form_for
		Include the code with form_for in app/views/new.html.erb
			<% provide(:title, 'Sign up') %>
			<h1>Sign up</h1>

			<div class="row">
			  <div class="span6 offset3">
			    <%= form_for(@user) do |f| %>

			      <%= f.label :name %>
			      <%= f.text_field :name %>

			      <%= f.label :email %>
			      <%= f.text_field :email %>

			      <%= f.label :password %>
			      <%= f.password_field :password %>

			      <%= f.label :password_confirmation, "Confirmation" %>
			      <%= f.password_field :password_confirmation %>

			      <%= f.submit "Create my account", class: "btn btn-large btn-primary" %>
			    <% end %>
			  </div>
			</div>
		And app/controllers/users_controller.rb
			class UsersController < ApplicationController
			  ...
			  def new   
			    @user = User.new
			  end

			    def create
				    @user = User.new(params[:user])    # Not the final implementation!
				    #Equivalent to
				    #@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")
				    #The final implementation
				    @user = User.new(user_params)
				    if @user.save
				      # Handle a successful save.
				      flash[:success] = "Welcome to the Sample App!"
				      redirect_to @user
				    else
				      render 'new'
				    end
			    end
			     private
				    def user_params
				      params.require(:user).permit(:name, :email, :password,
				                                   :password_confirmation)
				    end
			end
		- Now test passes.
	Signup Error Messages
		Object errors.full_messages, has the array of errors.
		In views/users/new.html.erb include
			<%= render 'shared/error_messages' %>		
			Shared is related to partials expected to be used in views in multiple controllers.

			Create app/views/shared/_error_messages.html.erb
				<% if @user.errors.any? %>
			  <div id="error_explanation">
			    <div class="alert alert-error">
			      The form contains <%= pluralize(@user.errors.count, "error") %>.
			    </div>
			    <ul>
			    <% @user.errors.full_messages.each do |msg| %>
			      <li>* <%= msg %></li>
			    <% end %>
			    </ul>
			  </div>
			<% end %>

			- pluralize is a magic that make the word("error") plural if the first parameter is >0.
			- error_explanation and alert alert-error define a good layout for errors.
				They are specified in custom.css.scss
	Finishing the form
		Just include this code after "if @user.save"
		redirect_to @user
	Flash
		Message that appears in the following page after a submit.
		Variable flash that is used as a hash.
		In app/views/layouts/application.html.erb include
		<% flash.each do |key, value| %>
        	<div class="alert alert-<%= key %>"><%= value %></div>
      	<% end %>

      	Ex: if flash[:success] = "Welcome to the Sample App!"
      	the output is:
      	<div class="alert alert-success">Welcome to the Sample App!</div>

      	Here, key is "success", should exists class "alert-success".
      	- And after @user.save in UserController class, include
      		flash[:success] = "Welcome to the Sample App!"

http://railsapps.github.io/installing-rails.html
http://www.psychocats.net/ubuntu/virtualbox


