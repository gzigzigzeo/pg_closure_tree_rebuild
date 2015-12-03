module PgClosureTreeRebuild
  class Runner
    def initialize(db, table, hierarchies = nil, parent_id = 'parent_id', id = 'id')
      @db = db

      hierarchies ||= "#{table.singularize}_hierarchies"
      parent_id ||= 'parent_id'
      id ||= 'id'

      @scope = db[table.to_sym]
      hierarchies = hierarchies.to_sym

      @builder = PgClosureTreeRebuild::Builder.new(
        @scope,
        hierarchies.to_sym,
        id: id.to_sym,
        parent_id: parent_id.to_sym
      )
    end

    def run
      puts 'Calculating chains...'
      bar = ProgressBar.create(total: @builder.chains.size)

      puts "Records: #{@scope.count}"

      puts 'Importing...'
      @builder.rebuild(@db) { bar.increment }
    end
  end
end
