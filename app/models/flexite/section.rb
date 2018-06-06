module Flexite
  class Section < ActiveRecord::Base
    include Presentable

    presenter :section
    attr_accessible :name
    has_many :configs, dependent: :destroy, as: :parent
    belongs_to :section, foreign_key: :parent_id, touch: true

    def to_tree_node
      {
        id: id,
        type: self.class.name,
        selfHref: Engine.routes.url_helpers.section_path(self),
        text: name,
        dataHref: Engine.routes.url_helpers.parent_configs_path(self, self.class.name.underscore, format: :json),
        nodes: nodes_count > 0 ? [] : nil,
        selectable: true,
        ajaxOnSelect: false
      }
    end

    def selectable=(*)
    end

    def nodes_count
      self[:nodes_count] || 0
    end

    def self.tree_view
      joins("LEFT JOIN #{Config.table_name} ON #{Config.table_name}.parent_id = #{table_name}.id AND #{Config.table_name}.parent_type = '#{model_name}'")
      .select(["#{table_name}.id", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(#{Config.table_name}.id) as nodes_count"])
      .group("#{table_name}.id")
    end

    def self.parent_dropdown
      select([:id, :name, :updated_at])
    end
  end
end
