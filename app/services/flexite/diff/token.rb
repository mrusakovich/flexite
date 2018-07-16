module Flexite
  class Diff
    class Token
      def initialize(string_token)
        @token = string_token.encode(Encoding::UTF_8)
      end

      def valid?
        secure_compare(Flexite.config.migration_token, @token)
      end

      def invalid?
        !valid?
      end

      private

      # Constant-time comparison algorithm to prevent timing attacks
      #
      # see Devise.secure_compare
      #
      # @param this_str [String] first value
      # @param that_str [String] second value
      #
      # @return [TrueClass, FalseClass] true or false
      #
      def secure_compare(this_str, that_str)
        return false if this_str.blank? || that_str.blank? || this_str.bytesize != that_str.bytesize

        this_str_bytes = this_str.unpack "C#{this_str.bytesize}"
        that_str.each_byte.reduce(0) do |memo, byte|
          memo | byte ^ this_str_bytes.shift
        end == 0
      end
    end
  end
end
