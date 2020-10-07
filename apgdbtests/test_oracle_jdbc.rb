#!/usr/bin/env ruby
require 'apgdb'
require 'apgsecrets'
require 'slop'

# Help Text Display Options
def help(opts)
  puts 'Demo Script for using a Oracle Jdbc Connection'
  puts opts
end
# Definition and Parsing of the Commandline Options
opts = Slop.parse do |o|
  o.string '-u', '--user', 'Db User. mandatory'
  o.string '-t', '--target', 'Db Target, like CHEI212, default CHEI212', default: 'CHEI212'
  o.on '-h', '--help' do
    help(o)
    exit
  end
end
# Precondition Tests
unless opts[:user]
  help(opts)
  puts 'You must enter Db Username'
  exit
end
# Establishment of Preconditions : Entering and Storing Password
s = Secrets::Store.new
pw = s.prompt_only_when_not_exists(opts[:user], 'Please enter Db Password and enter return:')

# Oracle Jdbc Connection creation
conn = Oracle::Connection.new(opts[:target])
statement = conn.connect(opts[:user],pw)

# Usage Scenarios of Jdbc statement
rs = statement.execute_query('select * from DRUCKER_f')
while rs.next do
  puts "DRUID: #{rs.getObject('DRU_ID')}, ALIAS: #{rs.getObject('ALIAS')}, BEZEICHNUNG: #{rs.getObject('BEZEICHNUNG')}"
end
conn.close
