require 'pg'
require 'pry-byebug'

module Sesh
  class Connection
    def initialize
      @db = PG.connect(host: 'localhost', dbname: 'sesh')
    end

    def persist_user(user)
      @db.exec(%q[
        INSERT INTO users (username, password_digest)
        VALUES ($1, $2);
      ], [user.username, user.password_digest])
    end

    def get_user_by_username(username)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE username = '#{username}';
      ])

      user_data = result.first
      
      if user_data
        build_user(user_data)
      else
        nil
      end
    end

    def username_exists?(username)
      result = @db.exec(%Q[
        SELECT * FROM users WHERE username = '#{username}';
      ])

      if result.count > 1
        true
      else
        false
      end
    end

    def build_user(data)
      Sesh::User.new(data['username'], data['password_digest'])
    end

    ############# CREATE MATCH ###############
    def create_match(player1,player2)
      @db.exec_params(%Q[ INSERT INTO matches (player1,player1_win_count,player2_win_count)
      VALUES ($1,$2,$3) RETURNING id;], [player1,0,0])
  end

  def self.dbi
    @__db_instance ||= Connection.new
  end
end
