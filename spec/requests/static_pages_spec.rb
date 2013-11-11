require 'spec_helper'

describe "Static pages" do

  subject { page }
###############
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page Avoiding duplication" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page Avoiding duplication" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
    it { should have_title('| Help') }
  end


################  

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Sample App') }
    it { should have_title(full_title('')) }
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end

  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_selector('h1', text: 'Contact') }
    it { should have_title(full_title('Contact')) }
  end

  # descrite "Click in All links" do
	 #   it "should have the right links on the layout" do
	 #    visit root_path
	 #    click_link "About"
	 #    expect(page).to have_title(full_title('About Us'))
	 #    click_link "Help"
	 #    expect(page).to # fill in
	 #    click_link "Contact"
	 #    expect(page).to # fill in
	 #    click_link "Home"
	 #    click_link "Sign up now!"
	 #    expect(page).to # fill in
	 #    click_link "sample app"
	 #    expect(page).to # fill in
  # end

end

describe "StaticPages" do

	 let(:base_title) { "Ruby on Rails Tutorial Sample App" }

#   describe "GET /static_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get static_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end
	describe "Home page" do

	    it "should have the content 'Sample App'" do
	      #visit '/static_pages/home'
	      #visit '/home'
	      visit home_path
	      expect(page).to have_content('Sample App')
	    end
	    it "should have the content 'Sample App Using Root'" do
	      #visit '/static_pages/home'
	      #visit '/home'
	      visit root_path
	      expect(page).to have_content('Sample App')
	    end

	    it "should have the base title using dash /" do
	      #visit '/static_pages/home'
	      #visit '/home'
	      visit '/'
	      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
	    end

		it "should not have a custom page title" do
		      #visit '/static_pages/home'
		      #visit '/home'
		      visit home_path
		      expect(page).not_to have_title('| Home')
	    end

	end

	describe "Help page" do

		it "should have the content 'Help'" do
		  #visit '/static_pages/help'
		  #visit '/help'
		  visit help_path
		  expect(page).to have_content('Help')
		end

	    it "should have the title 'Help'" do
	      #visit '/static_pages/help'
	      #visit '/help'
	      visit help_path
	      expect(page).to have_title("#{base_title} | Help")
	    end
	  end

	describe "About page" do

		it "should have the content 'About Us'" do
		  #visit '/static_pages/about'
		  #visit '/about'
		  visit about_path
		  expect(page).to have_content('About Us')
		end

		it "should have the title 'About Us'" do
	      #visit '/static_pages/about'
	      #visit '/about'
	      visit about_path
	      expect(page).to have_title("#{base_title} | About Us")
	    end
	end

	describe "Contact page" do

		it "should have the content 'Contact'" do
		  #visit '/static_pages/contact'
		  #visit '/contact'
		  visit contact_path
		  expect(page).to have_content('Contact')
		end

		it "should have the title 'Contact'" do
		  #visit '/static_pages/contact'
		  #visit '/contact'
		  visit contact_path
		  expect(page).to have_title("#{base_title} | Contact")
		end

		it "should have the content 'Contact 1'" do
		  #visit '/static_pages/contact'
		  #visit '/contact'
		  visit contact_path
		  expect(page).to have_content('Contact')
		end

		it "should have the title 'Contact 2'" do
		  #visit '/static_pages/contact'
		  #visit '/contact'
		  visit contact_path
		  expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
		end
	end

 end