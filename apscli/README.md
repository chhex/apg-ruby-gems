
## Apscli

Gem Wrapper for the apscli jar. It doesn't have any additional
dependency beyond this jar.

## Installation

~~~
gem install apscli 
~~~

## Usage

As soon as the gem is install the executable

[apscli](./bin/apscli)<!-- @IGNORE PREVIOUS: link -->

is in the PATH and can be invoked.

For the detailed options, see

~~~
apscli -h 
~~~

## Development

Upgrade of the apscli jar: Copy the required Version of the
aps-patch-cli-fat*.jar into the [lib directory](./lib)

If the invocation changes, adopt [apscli.rb](./lib/apscli.rb)
accordingly.

Currently the client is created as follows:

~~~
 def Apscli.run(args)
    puts 'Running groovy apscli from ruby'
    cli = com.apgsga.patch.service.client.PatchCli.create()
    cli.process(args)
 end
~~~

To install this gem onto your local machine, run `bundle exec rake
install`.

To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which will create
a git tag for the version, push git commits and tags, and push the
`.gem` file to [Apgs Gem Repo](https://artifactory4t4apgsga.jfrog.io/artifactory/api/gems/apgGem)..

