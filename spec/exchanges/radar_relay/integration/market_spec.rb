require 'spec_helper'

RSpec.describe 'RadarRelay integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:bat_weth_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BAT', target: 'WETH', market: 'radar_relay') }

  it 'fetch pairs' do
    pairs = client.pairs('radar_relay')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'radar_relay'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'radar_relay', base: bat_weth_pair.base, target: bat_weth_pair.target
    expect(trade_page_url).to eq "https://app.radarrelay.com/BAT/WETH"
  end

  it 'fetch ticker' do
    ticker = client.ticker(bat_weth_pair)

    expect(ticker.base).to eq 'BAT'
    expect(ticker.target).to eq 'WETH'
    expect(ticker.market).to eq 'radar_relay'
    expect(ticker.last).to be_a Numeric
    expect(ticker.last).to be < 100 # Test if number is reasonable
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(bat_weth_pair)

    expect(order_book.base).to eq 'BAT'
    expect(order_book.target).to eq 'WETH'
    expect(order_book.market).to eq 'radar_relay'

    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 2
    expect(order_book.bids.count).to be > 2
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end
end
