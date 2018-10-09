module Flexite
  class DiffPresenter < SimpleDelegator
    def initialize(object, template)
      @object = object
      super(template)
    end

    def path
      tree = Config.roots
      path = @object.path.each_with_object([]) do |value, result|
        break if tree.nil?

        if value.is_a?(Integer) && tree[value].present?
          result << tree[value]['name']
        end
        tree = tree.dig(value)
      end.join(' -> ')
      content_tag(:div, class: 'raw') { path }
    end

    def changes
      send("#{@object.type}_changes")
    end

    private

    define_method('~_changes') do
      content_tag(:div) do
        concat(content_tag(:div, class: 'raw my-2') do
                 concat(label_tag('Current value:'))
                 concat(@object.changes.first)
               end)
        concat(content_tag(:div, class: 'raw my-2') do
                 concat(label_tag('New value:'))
                 concat(@object.changes.last)
               end)
      end
    end

    %w[- +].each do |symbol|
      define_method("#{symbol}_changes") do
        content_tag(:div) do
          concat(content_tag(:div, class: 'raw') do
            concat(label_tag('Node name:'))
            concat(@object.changes[0]['name'])
          end)
          concat(content_tag(:div, class: 'raw') do
            concat(label_tag('Node description:'))
            concat(@object.changes[0]['description'])
          end)
          if @object.changes[0]['entry'].present?
            concat(content_tag(:div, class: 'raw') do
              concat(label_tag('Value:'))
              concat(@object.changes[0]['entry']['value'])
            end)
          end
        end
      end
    end
  end
end
