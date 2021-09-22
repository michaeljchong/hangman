class Dictionary
  attr_reader :secret_word

  def initialize
    file = File.open('5desk.txt', 'r')
    word_list = file.readlines.map { |word| word.strip.downcase }
    @dictionary = word_list.filter do |word|
      word.length > 5 && word.length < 12
    end
    @secret_word = @dictionary.sample
  end

  def new_secret_word
    @secret_word = @dictionary.sample
  end
end

class Player
  def initialize
    @name = ''
  end

  def name?
    print 'What is your name? (default: Player) '
    name = gets.chomp
    @name = name.empty? ? 'Player' : name
  end

  def guess
    print 'Which letter do you think the word includes? '
    while (letter = gets.chomp)
      break if letter.length == 1 && /[[:alpha:]]/ =~ letter

      print 'Invalid input. Enter a single alphabetic charcter: '
    end
    letter
  end
end

class Game
  def initialize
    @dictionary = Dictionary.new
    @player = Player.new
    @correct_letters = []
    @num_wrong_guesses = 0
  end

  def check_guess(letter)
    if @dictionary.secret_word.chars.include?(letter)
      @correct_letters.include?(letter) ? return : @correct_letters << letter
    else
      @num_wrong_guesses += 1
    end
  end

  def play
    @player.name?
    until @num_wrong_guesses == 6 || @correct_letters.sort == @dictionary.secret_word.chars.uniq.sort
      print @dictionary.secret_word
      letter = @player.guess
      check_guess(letter)
      puts "Number of wrong guesses: #{@num_wrong_guesses}"
    end
    @num_wrong_guesses == 6 ? 'You lose!' : 'You win!'
  end
end

p Game.new.play
