require 'spec_helper'

describe PgClosureTreeRebuild::Builder do
  let(:db) { Sequel.sqlite }
  let(:table) { db[:table] }
  let(:hierarchies_table) { db[:table_hierarchies] }

  subject { described_class.new(table, :table_hierarchies) }

  before do
    db.create_table!(:table) do
      primary_key :id
      column :parent_id, :integer
      column :name, :string
    end

    db.create_table!(:table_hierarchies) do
      column :descendant_id, :integer
      column :ancestor_id, :integer
      column :generations, :integer
    end

    table.insert(id: 1, name: 'r1')
    table.insert(id: 2, name: 'r2')
    table.insert(id: 3, name: 'r3', parent_id: 1)
    table.insert(id: 4, name: 'r4', parent_id: 1)
    table.insert(id: 5, name: 'r5', parent_id: 3)
    table.insert(id: 6, name: 'r6', parent_id: 2)
  end

  it '#tuples' do
    expect(subject.tuples).to eq([
      [1, nil],
      [2, nil],
      [3, 1],
      [4, 1],
      [6, 2],
      [5, 3]
    ])
  end

  context '#chains' do
    context 'without cyclomatic references' do
      it 'returns correct chains' do
        expect(subject.chains.sort).to be == [
          [1, 1, 0], [1, 3, 1], [1, 4, 1], [1, 5, 2],
          [2, 2, 0], [2, 6, 1],
          [3, 3, 0], [3, 5, 1],
          [4, 4, 0],
          [5, 5, 0],
          [6, 6, 0]
        ].sort
      end
    end

    context 'has cyclomatic references' do
      before do
        table.insert(id: 7, name: 'r7', parent_id: 8)
        table.insert(id: 8, name: 'r8', parent_id: 7)
      end

      it do
        expect { subject.chains }.to raise_error(
          'Cycle reference detected: 8 <=> 7'
        )
      end
    end
  end

  context '#rebuild' do
    let(:pgcopy) { %(PGCOPY\n\xFF\r\n\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0000\u0003\u0000\u0000\u0000\u0004\u0000\u0000\u0000\u0001\u0000\u0000\u0000\u0004) }

    it 'succeeds' do
      expect(db).to(
        receive(:copy_into)
          .with(
            :table_hierarchies,
            columns: [:ancestor_id, :descendant_id, :generations],
            format: :binary,
            data: ->(v) { v[0..32] == pgcopy }
          )
      )
      subject.rebuild(db)
    end
  end
end
