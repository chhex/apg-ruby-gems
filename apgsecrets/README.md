# Apgsecrets

This gem provides a uniform way to prompt for a user password. It also
caches the password in a File Cache for a given time period, so that
multiple invocation the password doesn't have to be reentered.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apgsecrets'
```
And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install apgsecrets

## Usage

Create a new Secrets Store `s = Secrets::Store.new` with default values.

Create a new Secrets Store `s = Secrets::Store.new(600)` with explicit
time to live in seconds.

Save a User and Password: `s.save("someuser", "verysecrectpassword")`.

The Password will stored to a "timed" store encrypted:

~~~
cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt 
key = cipher.random_key
cipher.key = key s = cipher.update(pw) + cipher.final
~~~

Test if the User has a Password saved: `s.exist("someuserother")`

Retrieve the Password decrypted: `s.retrieve("someuser")`

Prompt for a Password by default from Stdin with a Prompt Text : `result = s.prompt("Some Display text")`

The Password is returned, but the user input is not displayed

Prompt and Save the Password `s.prompt_and_save("yetanotheruser", "Some
Display text")`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake
install`.

To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the
`.gem` file to [Apgs Gem Repo](https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGem)..
