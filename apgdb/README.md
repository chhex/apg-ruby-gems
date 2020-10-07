# Apgdb

Jruby gem as wrapper for the Oracle jdbc Driver, which establishes a
connection according to Apg conventions.

There are two types of connections possible:

- Plain Oracle Connection based on Oracle Jdbc Api, see https://docs.oracle.com/cd/E18283_01/appdev.112/e13995/toc.htm
- Sequel based connection, see https://github.com/jeremyevans/sequel

both use the java jdbc driver from Oracle, Version: 11.2.0.2.0, see the
[jars](./lib/jars) directory

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apgdb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install apgdb

## Usage

Create a Oracle Jdbc Connection : `conn = Oracle::Connection.new("CHEI212")`

Connect : `statement = conn.connect("someuser","somepasswd"`

Do something with the statement: `rs = statement.execute_query("select *
from some_table")`

Create a Sequel Connection and do something with it:
~~~
conn = Sequel::Connection.new("CHEI212")
DB = conn.connect("someuser","andpasswd")
DB['select * from conn = Sequel::Connection.new("CHEI212")
DB = conn.connect("someuser","andpasswd")
DB['select * from some_table'].each do |row|
  p row
end
~~~

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`.

To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the
`.gem` file to [Apgs Gem Repo](https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGem).



