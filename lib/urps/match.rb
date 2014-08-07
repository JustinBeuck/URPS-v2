module Arena
  class Match
    attr_accessor  :player1_win_count, :player2_win_count, :match_id

    def initialize(player1, player2=nil)
      @player1_win_count = 0
      @player2_win_count = 0
      @match_id = match_id
    end
  end
end