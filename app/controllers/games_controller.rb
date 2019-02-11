require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = create_grid(10)
  end

  def score
    @answer = params[:answer]
    @word = params[:letters]
    @reponse = ''
    verify_word
  end

  def create_grid(grid_size)
    Array.new(grid_size.to_i) { ('A'..'Z').to_a.sample }
  end

  def verify_word
    array = @answer.split('')
    @word.split.each do |letter|
      if array.include?(letter.downcase)
        array.slice!(array.index(letter.downcase))
      end
    end
    if array.length > 0
      @response = 'Not good mister !'
    elsif call_dictionnary(@answer) == false
      @response = "Sorry but #{@answer} is not an english word"
    else
      @response = "Congratulations #{@answer} is a valid word"
    end
  end

  def call_dictionnary(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    user['found']
  end
end
