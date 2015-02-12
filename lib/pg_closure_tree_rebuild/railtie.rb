module PgClosureTreeRebuild
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__), '../../tasks/closure_tree.rake')
    end
  end
end
