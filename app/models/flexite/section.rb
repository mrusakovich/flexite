module Flexite
  class Section < ActiveRecord::Base
    include Presentable

    presenter :section
    attr_accessible :name
    has_many :configs, dependent: :destroy, as: :parent
    belongs_to :section, foreign_key: :parent_id, touch: true

    def to_tree_node
      {
        text: name,
        href: Engine.routes.url_helpers.parent_configs_path(self.class.name.underscore, self, format: :json),
        nodes: nodes_count > 0 ? [] : nil,
        selectable: nodes_count > 0 ? false : true
      }
    end

    def self.tree_view(parent_id)
      relation = joins("LEFT JOIN #{Config.table_name} ON #{Config.table_name}.parent_id = #{table_name}.id AND #{Config.table_name}.parent_type = '#{model_name}'")
        .select(["#{table_name}.id", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(#{Config.table_name}.id) as nodes_count"])
        .where(parent_id: parent_id)

      ["flexite/sections/query-#{parent_id}-#{Digest::MD5.hexdigest(relation.to_sql)}-#{relation.maximum(:updated_at).to_i}", relation.group("#{table_name}.id")]
    end
  end
end
