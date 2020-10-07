#!/usr/bin/env ruby
require 'apgdb'
require 'apgsecrets'
require 'slop'

# Help Text Display Options
def help(opts)
  puts 'Demo Script for using a Sequel Connection with a explicit select statement \n'
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
# Entering and Storing Password
s = Secrets::Store.new
pw = s.prompt_only_when_not_exists(opts[:user], 'Please enter Db Password and enter return:')

# Swquel Connection creation and connecting
conn = Sequel::Connection.new(opts[:target])
DB = conn.connect(opts[:user],pw)

# Usage Scenarios of DB
puts '---> Explict select statement'
DB['select * from DRUCKER_f'].each do |row|
  p row
end
puts '---> Implicit select statement'
DB[:drucker_f].order(:alias).each do |row|
  p row
end
puts '---> Implicit select statement with where clause '
statement = DB[:drucker_f].where(:bezeichnung => 'ZHG_Montagne_C308_552379056' )
puts statement.first
puts '---> Explicit select statement with where clause and parameter'
DB['select * from DRUCKER_f t where t.bezeichnung like ?','ZHG%'].each do |row|
  p row
end
puts 'Thats all, for more on Sequel see: https://github.com/jeremyevans/sequel'
