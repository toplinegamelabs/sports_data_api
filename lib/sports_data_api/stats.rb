module SportsDataApi
  class Stats
    def initialize(stats)
      if stats
        stats_ivar = self.instance_variable_set("@statistics", {})
        self.class.class_eval { attr_reader :"statistics" }
        stats.each_pair do |parent_k, parent_v|
          if parent_v.is_a? Hash
            parent_k = parent_k == 'total' ? '' : "#{parent_k}_"
            parent_v.each_pair do |child_k, child_v|
              if child_v.is_a? Hash
                child_v.each_pair do |grandchild_k, grandchild_v|
                  stats_ivar["#{parent_k}#{child_k}_#{grandchild_k}".to_sym] = grandchild_v
                end
              else
                stats_ivar["#{parent_k}#{child_k}".to_sym] = child_v
              end
            end
          else
            stats_ivar[parent_k.to_sym] = parent_v
          end
        end
      end
    end
  end
end
