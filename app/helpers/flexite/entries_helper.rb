module Flexite
  module EntriesHelper
    ENTRY_TYPE_OPTIONS = [
      ['String', 'Flexite::StrEntry'],
      ['Symbol', 'Flexite::SymEntry'],
      ['Boolean', 'Flexite::BoolEntry'],
      ['Array', 'Flexite::ArrEntry'],
      ['Integer', 'Flexite::IntEntry']
    ].freeze

    def render_entries(entries, form)
      content_tag :div, id: "array-entries-#{form.options[:index]}" do
        entries.each_with_index do |entry, index|
          concat render_entry(entry, form, index)
        end
      end
    end

    def entry_type_select(f = nil)
      if f.present?
        f.select :type, options_for_select(ENTRY_TYPE_OPTIONS), {}, class: 'form-control'
      else
        select_tag :new_entry_type, options_for_select(ENTRY_TYPE_OPTIONS), class: 'form-control'
      end
    end

    private

    def render_entry(entry, form, index)
      cache entry do
        entry_form = entry.class.form(entry.form_attributes)

        concat(form.simple_fields_for(:entries, entry_form, index: index) do |fields|
          delete_link = link_to 'Delete', destroy_array_entries_path(id: entry.id, selector: "#{fields.object_name}-#{index}-#{entry.id}"),
                                remote: true, method: :delete, class: 'btn btn-danger'

          concat(content_tag(:div, id: "#{fields.object_name}-#{index}-#{entry.id}") do
            concat fields.input :id, as: :hidden
            concat fields.input :type, as: :hidden
            concat render "types/#{entry_form.view_type}", f: fields, delete_link: delete_link
          end)
        end)
      end
    end
  end
end
