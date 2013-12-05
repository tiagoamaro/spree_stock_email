require 'spec_helper'

describe Spree::StockEmailsController do
  let(:user) { mock_model(Spree.user_class, :has_spree_role? => true, :last_incomplete_spree_order => nil, :spree_api_key => 'fake', :email => 'myemail@email.com') }

  before(:each) do
    controller.stub spree_current_user: user
    request.env["HTTP_REFERER"] = 'where_i_came_from'
  end

  describe 'POST stock_emails' do
    let(:variant) { create(:variant) }

    it 'redirects back if variant is not found' do
      spree_post :create, 'stock_email' => { email: 'anything' }
      response.should redirect_to "where_i_came_from"
    end

    describe 'flash messages' do
      it 'shows success message' do
        spree_post :create, 'stock_email' => { variant: variant }
        flash[:success].should have_content variant.product.name
        flash[:success].should have_content 'is back in stock'
      end

      it 'shows error message' do
        create(:stock_email, variant: variant, email: user.email, sent_at: nil)
        spree_post :create, 'stock_email' => { variant: variant }
        flash[:notice].should have_content 'Already registered'
      end
    end

    context 'user is logged in' do
      it 'creates a stock email with user email' do
        spree_post :create, 'stock_email' => { variant: variant }

        stock_email = Spree::StockEmail.first
        stock_email.email.should eq user.email
      end
    end

    context 'user is not logged in' do
      it 'creates a stock email with parameter email' do
        controller.stub spree_current_user: nil
        spree_post :create, 'stock_email' => { variant: variant, email: 'theemail@email.com' }

        stock_email = Spree::StockEmail.first
        stock_email.email.should eq 'theemail@email.com'
      end
    end
  end
end