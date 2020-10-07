# Example Scripts using the *apgdb* and *apgsecrets* gems

This repo contains two scripts, which use the Apg gems
[apgdb](https://github.com/apgsga-it/apgdb) and
[apgsecrets](https://github.com/apgsga-it/apgsecrets) :

- [test_oracle_jdbc.rb](./test_oracle_jdbc.rb) : an example using a
  Oracle Jdbc based Connection
- [test_sequel.rb](./test_sequel.rb) : examples using a Sequel based
  Connection for quering the Database

The scripts also show how to parse command line options in standardized
way using the Gem [slop](https://github.com/leejarvis/slop)

## Installation required gems

The required gems are specified in the [Gemfile](Gemfile)<!-- @IGNORE PREVIOUS: link --> File. Also the
source of a gem is specified:

~~~
source 'https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGems' do
  gem 'apgdb'
  gem 'apgsecrets'
end
~~~

To install these dependencies locally, execute

    $ bundle install

## Usage

Executing a script without options, you get for example:

~~~
./test_sequel.rb -h                                                                                                                                                             6.2s  Do  1 Okt 08:02:33 2020
Demo Script for using a Sequel Connection with a explicit select statement 
usage: ./test_sequel.rb [options]
    -u, --user    Db User. mandatory
    -t, --target  Db Target, like CHEI212, default CHEI212
    -h, --help    
~~~

Entering valid command line options, tou will be prompted for the Db
Password of the User:

~~~
./test_sequel.rb -u che                                                                                                                                                        8.4s  Do  1 Okt 08:32:58 2020
Please enter Db Password and enter return: 

~~~

With the second execution of the scripts, you do not have to reenter the
Password again. The Password is cached encrypted on the Filesystem with
a default "time-to-live" period of 10 Min.

## Development

### Gems used

For Command Line Processing the
[slop](https://github.com/leejarvis/slop) Gem

For Db Connection retrieval and usage the Apg Gem [apgdb](https://github.com/apgsga-it/apgdb)

which uses in one scenario [sequel](https://github.com/jeremyevans/sequel)

For the prompting and encrypted storing of Passwords the Apg
[apgsecrets](https://github.com/apgsga-it/apgsecrets)






