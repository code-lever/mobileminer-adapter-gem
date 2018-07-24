## MobileMiner Adapter [![Build Status](https://travis-ci.org/code-lever/mobileminer-adapter-gem.png)](https://travis-ci.org/code-lever/mobileminer-adapter-gem) [![Code Climate](https://codeclimate.com/github/code-lever/mobileminer-adapter-gem.png)](https://codeclimate.com/github/code-lever/mobileminer-adapter-gem)

Just a simple Ruby gem to shove data at [MobileMiner](http://www.mobileminerapp.com).

## Installation

Install it yourself as:

    $ gem install mobileminer-adapter

## Usage

First, dump out a skeleton configuration file:

    $ mobileminer-adapter -s

This will write a `config.yaml` to the current directory.  Edit it to suit your email address, app key and miners.  After that, just run it:

    $ mobileminer-adapter -c config.yaml

And off we go.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
