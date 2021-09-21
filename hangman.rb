
class Game
  def initialize
    file = File.open('5desk.txt', 'r')
    dictionary = file.readlines.map { |word| word.strip }
    @filtered_dictionary = dictionary.filter do |word|
      word.length > 5 && word.length < 12
    end
  end

  def new_secret_word
    @secret_word = @filtered_dictionary.sample
  end
end

p Game.new.new_secret_word
