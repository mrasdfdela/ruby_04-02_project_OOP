require 'byebug'

class Board
  attr_accessor :board

  def initialize(board_size)
    @board =  Array.new(board_size){
                Array.new(board_size){
                  Square.new()
                } 
              }
  end

  def print_board
    # print label row
    top_row = " "
    self.board.each_index { |idx| top_row << " #{idx}"}
    puts top_row

    # print board rows
    board.each_with_index do |row, i|
      print_row = "#{ i }"
      row.each { |el| print_row += " #{el.mark}" }
      puts print_row
    end
  end
end

class Square
  attr_accessor :mark
  @@count = 0

  def initialize()
    @mark = "#"
    @@count += 1
  end

  def self.count
    @@count
  end
end

class Player
  attr_accessor :name, :player_num
  def initialize(num)
    print "Player #{num}, please enter your name: "
    @name = gets.chomp
  end
end

class TicTacToe
  attr_accessor :column, :row
  attr_reader :players, :game_board, :board_size, :game_end, :player_turn

  def initialize(num_players, board_size)
    @game_over = false
    
    @board_size = board_size
    @game_board = Board.new(board_size)

    @column = -1
    @row = -1
    @player_turn = 0
    
    @players = []
    (1..num_players).each { |i| @players.push(Player.new(i)) }
  end

  def select_position()
    print "#{@players[@player_turn].name}, choose a column:"
    @column = gets.chomp.to_i
    print "now choose a row:"
    @row = gets.chomp.to_i
  end

  def eval_position()
    next_turn = false
    until next_turn == true
      
      if eval_pos_valid? && eval_pos_open?
        @game_board.board[@row][@column].mark = @player_turn
        game_over?()
        @player_turn >= @players.length - 1 ? @player_turn = 0 : @player_turn += 1
        next_turn = true
      else
        puts "Invalid selection"
        select_position()
      end

    end
    
  end
  
  def eval_pos_valid?
    max = @board_size - 1
    @column.between?(0,max) && @row.between?(0,max)
  end
  
  def eval_pos_open?
    @game_board.board[@row][@column].mark == "#"
  end
  
  def game_over?
    board = @game_board.board
    # evaluate rows
    board.each { |row| eval_pos_win(row) }
    
    # evaluate columns
    (0...board.length).each do |i|
      eval_column = []
      (0...board.length).each do |j|
        eval_column.push(board[j][i])
      end
      eval_pos_win(eval_column)
    end

    # evaluate diagonals
    eval_diagonal = []
    (0...board.length).each do |i|
      eval_diagonal.push(board[i][i])
    end
    eval_pos_win(eval_diagonal)

    eval_diagonal_reverse = []
    (0...board.length).each do |i|
      j = board.length - i - 1
      eval_diagonal_reverse.push( board[i][j] )
    end
    eval_pos_win(eval_diagonal_reverse)

    # evaluate for full board
    mark_count = 0
    board.each do |row|
      row.each do |square|
        mark_count += 1 if square.mark != "#"
      end
    end

    if mark_count == Square.count
      @game_over = true
      puts "No more moves! This game ends in a draw!"
    end
  end

  def eval_pos_win(arr)
    if arr.all? {|el| el.mark == @player_turn}
      @game_over = true
      puts "#{@players[@player_turn].name} has won!"
    end 
  end

  def play_game  
    @game_over = false

    until @game_over == true
      @game_board.print_board
      select_position()
      eval_position()
    end

    @game_board.print_board
    puts "Good game!"
  end
end

new_game = TicTacToe.new(2,3)
new_game.play_game