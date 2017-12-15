require 'sinatra'
require 'datapaga'
require 'dotenv/load'
require 'json'

DP = DataPaga::Rest::Client.new do |config|
  config.api_key = ENV['DP_API_KEY']
  config.api_secret = ENV['DP_API_SECRET']
end

TXs = JSON.parse(DP.list)
Cards = JSON.parse(DP.cards)

get '/' do 
	erb :index
end

get '/store_balance' do
	SB = JSON.parse(DP.store_balance)
	StoreBalance = to_dollars(SB['response']['balance'])
	erb :store_balance
end

get '/txs/:id' do
  Detail = JSON.parse(DP.detail(id: params['id']))
  erb :show
end


get '/txs' do
	erb :txs
end

get '/cards' do
	erb :cards
end

get '/cards/:uuid' do
  CardDetail = JSON.parse(DP.card_detail(uuid: params['uuid']))
  CardBalance = to_dollars(CardDetail['response']['balance'])
  erb :show_card
end

def to_dollars(amount)
	amount.to_f/100.to_f
end

