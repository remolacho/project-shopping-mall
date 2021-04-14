require 'rails_helper'

RSpec.describe V1::GroupTitles::ListController, type: :controller do
  include_context 'user_stuff'
  include_context 'meta_data_stuff'
  include_context 'company_stuff'
  include_context 'store_stuff'
  include_context 'products_stuff'

  describe "GET #index" do
    it 'error section!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']

      get :index, params: { section: 'test' }, as: :json
      expect(response.status).to eq(422)
    end

    it 'success discount!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      product = products_category.last
      variant = product.product_variants.last
      variant.discount_value = 700
      variant.save

      get :index, params: { section: 'discount' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('discount')).to eq(true)
      expect(body.dig('titles').empty?).to eq(false)
      expect(body.dig('titles').size < group_titles.size).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success rating!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      product = products_category.last
      product.rating = 4
      product.save

      get :index, params: { section: 'rating' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('rating')).to eq(true)
      expect(body.dig('titles').empty?).to eq(false)
      expect(body.dig('titles').size < group_titles.size).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success recents!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      Product.update_all(created_at: Time.now + 30.days)
      product = products_category.last
      product.created_at = (Time.now - 25.days)
      product.save

      get :index, params: { section: 'recents' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('recents')).to eq(true)
      expect(body.dig('titles').empty?).to eq(false)
      expect(body.dig('titles').size < group_titles.size).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success discount empty!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      get :index, params: { section: 'discount' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('discount')).to eq(true)
      expect(body.dig('titles').empty?).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success rating empty!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      get :index, params: { section: 'rating' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('rating')).to eq(true)
      expect(body.dig('titles').empty?).to eq(true)
      expect(response.status).to eq(200)
    end

    it 'success recents empty!!!' do
      request.headers['secret-api'] = ENV['SECRET_API']
      group_titles
      Product.update_all(created_at: Time.now + 30.days)
      get :index, params: { section: 'recents' }, as: :json
      body = JSON.parse(response.body)
      expect(body.dig('success')).to eq(true)
      expect(body.dig('section').eql?('recents')).to eq(true)
      expect(body.dig('titles').empty?).to eq(true)
      expect(response.status).to eq(200)
    end
  end
end
