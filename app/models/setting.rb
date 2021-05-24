class Setting < ApplicationRecord
  VALUE_TYPES = OpenStruct.new({
    string: "string",
    integer: "integer",
    boolean: "boolean"
  })

  enum value_type: VALUE_TYPES.to_h

  validates :name, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value_type, presence: true

  def self.get name, default = nil
    setting = Setting.where(name: name).first
    return default unless setting

    case setting.value_type
    when "string"
      setting.value
    when "integer"
      Integer(setting.value)
    when "boolean"
      ActiveModel::Type::Boolean.new.cast(setting.value)
    end
  end

  def self.render value, vars = {}
    # create and run templates, filling member data variables
    ERB.new(value, trim_mode: nil, eoutvar: "@result").result_with_hash(vars)
  end
end
