require 'pg_closure_tree_rebuild'
require 'ruby-progressbar'
require 'sequel'
require 'active_support/core_ext/string/inflections'
require 'benchmark'

namespace :closure_tree do
  desc 'Rebuild hierarchy (TABLE, HIERARCHIES, DATABASE_URL, PARENT_ID, ID)'
  task :rebuild do
    puts Benchmark.measure {
      DB = Sequel.connect(ENV['DATABASE_URL'])

      table = ENV['TABLE']
      hierarchies = ENV['HIERARCHIES'] || "#{table.singularize}_hierarchies"
      parent_id = ENV['PARENT_ID'] || 'parent_id'
      id = ENV['ID'] || 'id'

      scope = DB[table.to_sym]
      hierarchies = hierarchies.to_sym

      builder = PgClosureTreeRebuild::Builder.new(
        scope,
        hierarchies.to_sym,
        id: id.to_sym,
        parent_id: parent_id.to_sym
      )

      puts 'Calculating chains...'
      bar = ProgressBar.create(total: builder.chains.size)

      puts "Records: #{scope.count}"

      puts 'Importing...'
      builder.rebuild(DB) { bar.increment }
    }
  end
end
