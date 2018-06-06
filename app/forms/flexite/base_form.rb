class Flexite::BaseForm
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = HashWithIndifferentAccess.new

    attributes.each do |name, value|
      send("#{name}=", value) rescue nil
      @attributes[name] = value
    end
  end

  def persisted?
    respond_to?(:id) && id.present?
  end

  def new_record?
    !persisted?
  end
end
