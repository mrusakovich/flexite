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
        href: Engine.routes.url_helpers.section_configs_path(self, format: :json),
        nodes: nodes_count > 0 ? [] : nil,
        selectable: nodes_count > 0 ? false : true
      }
    end

    def self.tree_view(parent_id)
      joins("LEFT JOIN #{Config.table_name} ON #{Config.table_name}.parent_id = #{table_name}.id")
      .select(["#{table_name}.id", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(#{Config.table_name}.id) as nodes_count"])
      .where(parent_id: parent_id)
      .group("#{table_name}.id")
    end
  end
end
