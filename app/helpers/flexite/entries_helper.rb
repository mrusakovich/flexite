module Flexite
  module EntriesHelper
    def render_entries(entries, form, entry_nesting = [[:entry], [:entries], [0]], increment_index = 2)
      entries.map do |entry|
        if respond_to?("render_#{entry.class.name.demodulize.underscore}")
          send("render_#{entry.class.name.demodulize.underscore}", entry, form, entry_nesting, increment_index)
        else
          render_simple(entry, form, entry_nesting)
        end.tap { entry_nesting[increment_index][0] += 1 }
      end.join.html_safe
    end

    private

    def render_arr_entry(entry, form, entry_nesting, increment_index)
      name = input_name(entry_nesting)
      array_nesting = entry_nesting.dup
      array_nesting.push([:entries], [0])

      cache "#{entry.cache_key}-#{__method__}" do
        output_buffer << (content_tag(:div, class: 'form-group') do
          concat (form.simple_fields_for(entry) do |fields|
            concat fields.input :id, as: :hidden, input_html: { name: name % :id }
            concat fields.input :type, as: :hidden, input_html: { name: name % :type }
          end)

          concat render_entries(entry.entries, form, array_nesting, increment_index + 2)
        end)
      end
    end

    def render_simple(entry, form, entry_nesting)
      name = input_name(entry_nesting)

      cache "#{entry.cache_key}-#{__method__}" do
        output_buffer << (form.simple_fields_for(entry) do |fields|
          concat fields.input :id, as: :hidden, input_html: { name: name % :id }
          concat fields.input :type, as: :hidden, input_html: { name: name % :type }
          concat fields.input :value, label: false, input_html: { class: 'form-control', name: name % :value }
        end)
      end
    end

    def input_name(entry_nesting)
      name = entry_nesting.each_with_object('') do |e, memo|
        memo << "[#{e.first.to_s}]"
      end

      "#{name}[%s]"
    end
  end
end
