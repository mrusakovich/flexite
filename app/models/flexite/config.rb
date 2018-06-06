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
        id: id,
        type: self.class.name,
        selfHref: Engine.routes.url_helpers.config_path(self),
        text: name,
        dataHref: selectable ? entry_href : configs_href,
        nodes: nodes,
        selectable: true,
        ajaxOnSelect: selectable
      }
    end

    def self.tree_view(parent)
      joins("LEFT JOIN #{table_name} AS configs_#{table_name} ON configs_#{table_name}.parent_id = #{table_name}.id AND configs_#{table_name}.parent_type = '#{model_name}'")
      .joins("LEFT JOIN #{Entry.table_name} ON #{Entry.table_name}.parent_id = #{table_name}.id AND #{Entry.table_name}.parent_type = '#{model_name}'")
      .select(["#{table_name}.id", "#{table_name}.selectable", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(configs_#{table_name}.id) as nodes_count", "#{Entry.table_name}.id AS entry_id"])
      .where(parent_id: parent.id, parent_type: parent.class.name).group("#{table_name}.id")
    end

    def self.parent_dropdown
      select([:id, :name, :updated_at]).where(selectable: false)
    end

    def nodes_count
      self[:nodes_count]
    end

    def entry_id
      self[:entry_id]
    end

    def nodes
      if selectable
        return nil
      end

      nodes_count > 0 ? [] : nil
    end

    private

    def entry_href
      if entry_id.present?
        Engine.routes.url_helpers.edit_entry_path(entry_id, format: :js)
      else
        Engine.routes.url_helpers.select_type_entries_path(self, format: :js)
      end
    end

    def configs_href
      Engine.routes.url_helpers.parent_configs_path(self, self.class.name.underscore, format: :json)
    end
  end
end
