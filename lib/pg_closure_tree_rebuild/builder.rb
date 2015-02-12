module PgClosureTreeRebuild
  class Builder
    def initialize(table, hierarchies_table_name, options = {})
      @table = table
      @hierarchies_table_name = hierarchies_table_name.to_sym
      @id = options.delete(:id) || :id
      @parent_id = options.delete(:parent_id) || :parent_id
    end

    def rebuild(db)
      io = StringIO.new
      write_header(io)
      chains.each do |row|
        io.write([row.size].pack('n'))
        row.each { |v| write_integer(v, io) }
        yield if block_given?
      end
      write_close(io)
      copy(db, io)
    end

    def tuples
      @tuples ||= @table.order(@parent_id).select_map([@id, @parent_id])
    end

    def chains
      @chains ||= build_chains
    end

    private

    def build_chains
      [].tap do |c|
        tuples.each { |tuple| c.concat(chains_for(tuple[0])) }
      end
    end

    def chains_for(id)
      [].tap do |c|
        c << [id, id, 0]

        walk_up(id).each.with_index do |parent_id, index|
          c << [parent_id, id, index + 1]
        end
      end
    end

    def walk_up(id, cref = [])
      parent_id = tuples_hash[id]
      return [] unless parent_id

      if cref.include?(parent_id)
        fail "Cycle reference detected: #{id} <=> #{parent_id}"
      end

      [parent_id] + walk_up(parent_id, cref + [parent_id])
    end

    def tuples_hash
      @tuples_hash ||= index_tuples_by_id
    end

    def index_tuples_by_id
      {}.tap do |c|
        tuples.each do |(id, parent_id)|
          c[id] = parent_id
        end
      end
    end

    def write_integer(value, io)
      buf = [value].pack('N')
      io.write([buf.bytesize].pack('N'))
      io.write(buf)
    end

    def write_header(io)
      io.write("PGCOPY\n\377\r\n\0")
      io.write([0, 0].pack('NN'))
    end

    def write_close(io)
      io.write([-1].pack('n'))
      io.rewind
    end

    def copy(db, io)
      db[@hierarchies_table_name].truncate
      db.run('SET client_min_messages TO warning;')
      db.copy_into(
        @hierarchies_table_name,
        columns: COLUMNS, format: :binary, data: io.read
      )
    end

    COLUMNS = [:ancestor_id, :descendant_id, :generations]
  end
end
