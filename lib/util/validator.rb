module Magentwo
  class Validator
    class << self
      def check_presence model, *attributes
        case model
        when Hash
          attributes.each do |attribute|
            raise ArgumentError, "#{attribute} must be set" if model[attribute].nil?
          end
        when Magentwo::Base
          attributes.each do |attribute|
            raise ArgumentError, "#{attribute} must be set" if model.send(attribute).nil?
          end
        else
          raise ArgumentError "unknown model type, expected Child of Magentwo::Base or Hash"
        end
      end
    end
  end
end
