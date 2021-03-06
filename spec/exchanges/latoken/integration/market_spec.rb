require 'spec_helper'

RSpec.describe 'Latoken integration specs' do
  client = Cryptoexchange::Client.new
  let(:la_eth_pair) { Cryptoexchange::Models::MarketPair.new(base: 'la', target: 'eth', market: 'latoken') }

  it 'fetch pairs' do
    pairs = client.pairs('latoken')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'latoken'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'latoken', base: la_eth_pair.base, target: la_eth_pair.target
    expect(trade_page_url).to eq "https://latoken.com/exchange/ETH-LA"
  end

  it 'fetch ticker' do
    ticker = client.ticker(la_eth_pair)

    expect(ticker.base).to eq 'LA'
    expect(ticker.target).to eq 'ETH'
    expect(ticker.market).to eq 'latoken'
    expect(ticker.last).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end
end
