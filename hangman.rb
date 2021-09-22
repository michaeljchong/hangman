class Dictionary
  attr_reader :secret_word

  def initialize
    file = File.open('5desk.txt', 'r')
    word_list = file.readlines.map { |word| word.strip.downcase }
    dictionary = word_list.filter do |word|
      word.length > 5 && word.length < 12
    end
    @secret_word = dictionary.sample
  end
end

class Game
  MAX_GUESSES = 6

  def initialize
    @secret_word = Dictionary.new.secret_word.chars
    @correct_letters = []
    @incorrect_letters = []
    @num_wrong_guesses = 0
  end

  def guess_word
    print 'Enter a word to guess the entire word (hit enter to skip) '
    word = gets.chomp
    word.empty? ? '' : word.downcase
  end

  def check_word(word)
    word == @secret_word.join
  end

  def guess_letter
    print 'Which letter do you think the word includes? '
    while (letter = gets.chomp)
      break if letter.length == 1 && /[[:alpha:]]/ =~ letter

      print 'Invalid input. Enter a single alphabetic character: '
    end
    letter
  end

  def check_letter(letter)
    if @secret_word.include?(letter)
      @correct_letters.include?(letter) ? return : @correct_letters << letter
    else
      @incorrect_letters << letter
      @num_wrong_guesses += 1
    end
  end

  def display_letters
    @secret_word.each do |char|
      print @correct_letters.include?(char) ? "#{char} " : '_ '
    end
  end

  def result
    puts @num_wrong_guesses == MAX_GUESSES ? 'You lost!' : 'You won!'
    puts "The word was #{@secret_word.join}"
  end

  def play
    until @num_wrong_guesses == MAX_GUESSES || @correct_letters.sort == @secret_word.uniq.sort
      display_letters
      puts "| Number of wrong guesses: #{@num_wrong_guesses}/#{MAX_GUESSES}"
      puts "Incorrect letters: #{@incorrect_letters.join(' ')}"
      word = guess_word
      if word.empty?
        letter = guess_letter
        check_letter(letter)
      else
        check_word(word) ? break : @num_wrong_guesses += 1
      end
    end
    result
  end
end

Game.new.play
