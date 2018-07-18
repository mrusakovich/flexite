module Flexite
  class Config < ActiveRecord::Base
    include WithHistory

    attr_accessible :name, :selectable, :config_id, :description
    history_attributes :name, :config_id, :description

    delegate :value, to: :entry, allow_nil: true
    belongs_to :config, touch: true
    alias :parent :config
    alias :parent= :config=
    has_one :entry, as: :parent, dependent: :destroy
    has_many :configs, dependent: :destroy
    has_many :histories, as: :entity, dependent: :destroy
    scope :not_selectable, -> { select([:id, :name]).where(selectable: false) }
    scope :roots, -> { where(config_id: nil) }
    scope :order_by_name, -> { order("UPPER(#{table_name}.name)") }
    before_create :set_description

    def tv_node
      {
        id: id,
        editHref: Engine.routes.url_helpers.edit_config_path(self),
        selfHref: Engine.routes.url_helpers.config_path(self),
        newHref: Engine.routes.url_helpers.new_config_config_path(self),
        text: description,
        dataHref: selectable ? entry_href : configs_href,
        nodes: nodes,
        selectable: true,
        ajaxOnSelect: selectable
      }
    end

    def self.tree_view(parent_id)
      joins("LEFT JOIN #{table_name} AS configs_#{table_name} ON configs_#{table_name}.config_id = #{table_name}.id")
        .joins("LEFT JOIN #{Entry.table_name} ON #{Entry.table_name}.parent_id = #{table_name}.id AND #{Entry.table_name}.parent_type = '#{model_name}'")
        .select(["#{table_name}.id",
                 "#{table_name}.selectable",
                 "#{table_name}.description",
                 "#{table_name}.name",
                 "#{table_name}.updated_at",
                 "COUNT(configs_#{table_name}.id) AS nodes_count",
                 "#{Entry.table_name}.id AS entry_id"])
        .where(config_id: parent_id).group("#{table_name}.id")
        .order_by_name
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

    def self.t_nodes
      roots.includes(:configs, :entry).order_by_name.map(&:t_node)
    end

    def t_node
      node = {
        'name' => name,
        'description' => description,
        'class' => self.class.name
      }

      if configs.any?
        node.merge!('configs' => configs.includes(:configs, :entry).order_by_name.map(&:t_node))
      end

      if entry.present?
        node.merge!('entry' => entry.t_node)
      end

      node
    end

    def dig(level)
      if level.to_sym == :configs
        return send(level).order_by_name
      end

      send(level)
    end

    private

    def set_description
      return if description.present?
      self.description = name
    end

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
