module Oracle
  # This class provides a Oracle Jdbc connection based on Naming standards
  class Connection
    attr_reader :url,:connection,:statement
    def initialize(target)
      @url = "jdbc:oracle:thin:@#{target}.apgsga.ch:1521:#{target}"
    end

    def connect(user, pw)
      info = java.util.Properties.new()
      info.put('user', user)
      info.put('password', pw)
      @connection = java.sql.DriverManager.getConnection(@url, info)
      @statement = @connection.create_statement
    end

    def close
      @connection.close
      @statement.close
    end
  end

end

