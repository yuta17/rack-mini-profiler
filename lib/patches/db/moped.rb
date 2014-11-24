# Mongoid 3 patches
if SqlPatches.class_exists?("Moped::Node")
  class Moped::Node
    alias_method :process_without_profiling, :process
    def process(*args,&blk)
      return process_without_profiling(*args,&blk) unless SqlPatches.should_measure?

      result, record = SqlPatches.record_sql(args[0].log_inspect) do
        process_without_profiling(*args, &blk)
      end
      return result
    end
  end
end