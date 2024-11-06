class Api::V1::StocksController < ApplicationController
  def index
    symbols = params[:symbols].split(',')
    stocks = LatestStockPrice::Client.new.prices(symbols)
    render json: stocks
  end

  def show
    symbol = params[:id]
    stock = LatestStockPrice::Client.new.price(symbol)
    render json: stock
  end
end