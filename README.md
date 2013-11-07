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

			  full_title...  is a method created in spec/suport/utilities.rb
			  Identical to the methods created in helpers/application_helper.rb, which is used but the application

				def full_title(page_title)
				  base_title = "Ruby on Rails Tutorial Sample App"
				  if page_title.empty?
				    base_title
				  else
				    "#{base_title} | #{page_title}"
				  end
				end

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
			include in gemFile	gem 'bootstrap-sass', '2.3.2.0' and
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
	    $ git add .
		$ git commit -m "Finish layout and routes"
		$ git checkout master
		$ git merge filling-in-layout
		$ git push
		$ git push heroku
		$ heroku open
		$ heroku logs
