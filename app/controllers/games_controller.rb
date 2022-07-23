class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(9)
  end

  def score
    @word = params[:word].upcase
    @grid = JSON.parse(params[:grid])
    @include = included?(@word, @grid)
    @english_word = english_word?(@word)

    if @include
      if @english_word
        @result = "Congratulations! #{@word} is a valid English word!"
      else
        @result = "Sorry but #{@word} does not seem to be a valid English word..."
      end
    else
      @result = "Sorry but #{@word} can't be built out of #{@grid.join(", ")}"
    end
  end

  private

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    require "json"
    require "open-uri"

    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json['found']
  end
end
