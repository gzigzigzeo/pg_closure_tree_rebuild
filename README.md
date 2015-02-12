# PgClosureTreeRebuild

[![Build Status](https://travis-ci.org/gzigzigzeo/pg_closure_tree_rebuild.svg)](http://travis-ci.org/gzigzigzeo/pg_closure_tree_rebuild)
[![Code Climate](https://codeclimate.com/github/gzigzigzeo/pg_closure_tree_rebuild/badges/gpa.svg)](https://codeclimate.com/github/gzigzigzeo/pg_closure_tree_rebuild)
[![Test Coverage](https://codeclimate.com/github/gzigzigzeo/pg_closure_tree_rebuild/badges/coverage.svg)](https://codeclimate.com/github/gzigzigzeo/pg_closure_tree_rebuild)


Quick `#rebuild!` method implementation for [closure_tree](https://github.com/mceachen/closure_tree) on PostgreSQL.

Say you have a table with 1M+ hierarchical records and you want to migrate it to closure_tree. Initial rebuild of hierarchies table using the standard #rebuild! method will take a dramatically long time. This library speeds up the process. It makes all the calculations using pure in-memory array and writes the result using COPY FROM STDIN BINARY.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pg_closure_tree_rebuild'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pg_closure_tree_rebuild

## Usage

    $ bundle exec rake closure_tree:rebuild DATABASE_URL=postgres://localhost/tags TABLE=tags HIERARCHIES=tag_hierarchies PARENT_ID=parent_id ID=id

You can bypass all params except database URL and table name.

Rebuilding hierarchy for 1162537 records with 4 generations in average takes 2 minutes 58 seconds on my MacBook Pro i7 2.3GHz, while the rebuilding with the standard method takes hours.

## Contributing

1. Fork it ( https://github.com/gzigzigzeo/pg_closure_tree_rebuild/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
