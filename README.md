# PgClosureTreeRebuild

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

Rebuilding hierarchy for 1162537 records with 4 generations in average takes 2 mins 58 sec on my MacBook Pro i7 2.3 16GB vs hours using standard method.

## Contributing

1. Fork it ( https://github.com/gzigzigzeo/pg_closure_tree_rebuild/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
