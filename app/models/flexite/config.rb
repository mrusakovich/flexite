module Flexite
  class Config < ActiveRecord::Base
    include Presentable

    presenter :config
    attr_accessible :name
    belongs_to :parent, polymorphic: true, touch: true
    belongs_to :owner, foreign_key: :created_by
    has_one :entry, as: :parent, dependent: :destroy
    has_many :configs, as: :parent, dependent: :destroy
    delegate :value, :view_value, to: :entry, allow_nil: true

    def to_tree_node
      {
        text: name,
        href: treeview_href,
        nodes: nodes_count > 0 ? [] : nil,
        selectable: nodes_count > 0 ? false : true
      }
    end

    def self.tree_view(parent_id)
      relation = joins("LEFT JOIN #{table_name} AS configs_#{table_name} ON configs_#{table_name}.parent_id = #{table_name}.id")
        .joins("LEFT JOIN #{Entry.table_name} ON #{Entry.table_name}.parent_id = #{table_name}.id")
        .select(["#{table_name}.id", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(configs_#{table_name}.id) as nodes_count, #{Entry.table_name}.id AS entry_id"])
        .where(parent_id: parent_id)

      ["flexite/configs/query-#{parent_id}-#{Digest::MD5.hexdigest(relation.to_sql)}-#{relation.maximum(:updated_at)}", relation.group("#{table_name}.id")]
    end

    private

    def treeview_href
      if entry_id.present?
        Engine.routes.url_helpers.edit_entry_path(entry_id, format: :js)
      else
        Engine.routes.url_helpers.section_configs_path(self, format: :json)
      end
    end
  end
end
