require 'hanami/logger'
require 'rack/request_auditing'

module Hanami
  module ContextLogging
    class Formatter < Hanami::Logger::Formatter
      TIMESTAMP_FORMAT = '%FT%T.%L%z'

      private

      def _format(hash)
        audited_hash = hash.merge(context_tags)
        if audited_hash[:time]
          audited_hash[:time] = audited_hash[:time].strftime(TIMESTAMP_FORMAT)
        end

        message = audited_hash.delete(:message)
        components = audited_hash.map do |tag, tag_value|
          format_tag(tag, tag_value)
        end
        components << "#{message}#{NEW_LINE}"
        components.join(' ')
      end

      def context_tags
        context = Rack::RequestAuditing::ContextSingleton
        {
          correlation_id: context.correlation_id,
          request_id: context.request_id,
          parent_request_id: context.parent_request_id
        }
      end

      def format_tag(tag, tag_value)
        formatted_tag_value = format_tag_value(tag_value)
        "#{tag}=#{formatted_tag_value}"
      end

      def format_tag_value(tag_value)
        if tag_value
          "\"#{tag_value}\""
        else
          "\"\""
        end
      end
    end
  end
end
