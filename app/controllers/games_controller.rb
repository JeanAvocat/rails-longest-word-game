class GamesController < ApplicationController
  # require "json" // déjà require par Rails
  require "open-uri"

  def new
    @letters = []
    10.times do |letter|
      letter = ('A'..'Z').to_a[rand(26)]
      @letters << letter
    end
  end

  def parse_api(try_word)
    url = "https://wagon-dictionary.herokuapp.com/#{try_word}"
    word_checking = URI.open(url).read
    @word_from_api = JSON.parse(word_checking)
    # puts "#{word["found"]} - #{word["word"]}"
  end

  def score
    cache = ActiveSupport::Cache::MemoryStore.new
    @points = 0
    @word = params[:try]
    @given_letters = params[:letters].split("")
    parse_api(@word)
    if @word_from_api["found"]
      if @word.split("").all? do |letter|
          @given_letters.include?(letter.upcase)
        end
        @message = "Great job buddy! 😍😍😍"
        @points += (@word.length) ** 2
      else
        @message = "our word exists but you tried to cheat!! The used letters are not in the given grid. 😡😡😡"
      end
    else
      @message = "You're a looser. Your word doesn't even exist. 😭😭😭"
    end
  end
end
