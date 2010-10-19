module ActiveRecord
  class Base
    private
      def attributes_protected_by_default
        default = [ self.class.primary_key, self.class.inheritance_column ]
        default.concat ['created_at', 'created_on', 'updated_at', 'updated_on']
        default << 'id' unless self.class.primary_key.eql? 'id'
        default
      end
  end
end