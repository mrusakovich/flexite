module Flexite
  class Config < ActiveRecord::Base
    include WithHistory
    attr_accessible :name
    history_attributes :name, :config_id
    delegate :value, to: :entry, allow_nil: true

    belongs_to :config, touch: true
    belongs_to :owner, foreign_key: :created_by
    has_one :entry, as: :parent, dependent: :destroy
    has_many :configs, dependent: :destroy
    has_many :histories, as: :entity, dependent: :destroy

    scope :not_selectable, -> { select([:id, :name]).where(selectable: false) }

    validates :name, uniqueness: { scope: :config_id }

    def to_tree_node
      {
        id: id,
        editHref: Engine.routes.url_helpers.edit_config_path(self),
        selfHref: Engine.routes.url_helpers.config_path(self),
        newHref: Engine.routes.url_helpers.new_config_config_path(self),
        text: name,
        dataHref: selectable ? entry_href : configs_href,
        nodes: nodes,
        selectable: true,
        ajaxOnSelect: selectable
      }
    end

    def self.tree_view(parent_id)
      joins("LEFT JOIN #{table_name} AS configs_#{table_name} ON configs_#{table_name}.config_id = #{table_name}.id")
      .joins("LEFT JOIN #{Entry.table_name} ON #{Entry.table_name}.parent_id = #{table_name}.id AND #{Entry.table_name}.parent_type = '#{model_name}'")
      .select(["#{table_name}.id", "#{table_name}.selectable", "#{table_name}.name", "#{table_name}.updated_at", "COUNT(configs_#{table_name}.id) as nodes_count", "#{Entry.table_name}.id AS entry_id"])
      .where(config_id: parent_id).group("#{table_name}.id")
    end

    def nodes_count
      self[:nodes_count].to_i
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
      Engine.routes.url_helpers.config_configs_path(self, format: :json)
    end
  end
end
