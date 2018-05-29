module Flexite
  module EntriesHelper
    def render_entries(entries, form, entry_nesting = [[:entries], [0]], increment_index = 1)
      entries.map do |entry|
        html = case entry
          when ArrEntry
            render_array(entry, form, entry_nesting, increment_index)
          else
            render_simple(entry, form, entry_nesting)
        end

        entry_nesting[increment_index][0] += 1
        html
      end.join.html_safe
    end

    private

    def render_array(entry, form, entry_nesting, increment_index)
      content_tag(:div, class: 'form-group') do
        array_nesting = entry_nesting.dup
        array_nesting.push([:entries], [0])
        render_entries(entry.entries, form, array_nesting, increment_index + 2)
      end
    end

    def render_simple(entry, form, entry_nesting)
      name = entry_nesting.each_with_object('') do |e, memo|
        memo << "[#{e.first.to_s}]"
      end
      name = "#{name}[%s]"

      form.simple_fields_for :entries, entry do |fields|
        concat fields.input :id, as: :hidden, input_html: { name: name % :id }
        concat fields.input :type, as: :hidden, input_html: { name: name % :type }
        concat fields.input :value, label: false, input_html: { class: 'form-control', name: name % :value }
      end
    end
  end
end
