module HaveAttrAccessor
  RSpec::Matchers.define :have_attr_accessor do |field|
    match do |object|
      object.respond_to?(field) && object.respond_to?("#{field}=")
    end

    failure_message do |object|
      "expected attr_accessor for #{field} on #{object}"
    end

    failure_message_when_negated do |object|
      "expected attr_accessor for #{field} not to be defined on #{object}"
    end

    description do
      'assert there is an attr_accessor of ' \
      'the given name on the supplied object'
    end
  end
end
