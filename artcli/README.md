# Artcli

Intends to provide scripted variants of often used usage variants of the
[Artifactory Rest API](https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API)

The api can also be used directly, see below

## Installation

If you just intend to use artcli from command line
~~~
gem install artcli 
~~~

If you are using the [artcli Api](./lib/artcli/artifactory_cli.rb) from
another script add the followed line to your application's Gemfile:

```ruby
gem 'artcli'
```
And then execute:

    $ bundle install

## Usage

### Script

As soon as the gem is install the executable

[apscli](./bin/artcli)<!-- @IGNORE PREVIOUS: link -->

is in the PATH and can be invoked.

For the detailed options, see

~~~
artcli -h 
~~~

### Api

TODO

## Development

To install this gem onto your local machine, run `bundle exec rake
install`.

To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the
`.gem` file to [Apgs Gem Repo](https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGem)..