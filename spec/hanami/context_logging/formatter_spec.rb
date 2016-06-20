require 'spec_helper'

describe Hanami::ContextLogging::Formatter do
  describe '#_format' do
    it 'formats the hash with context and full timestamp' do
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:correlation_id).and_return('CORRELATIONID')
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:request_id).and_return('REQUESTID')
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:parent_request_id).and_return(nil)
      hash = {
        app: 'FooService',
        severity: 'ERROR',
        time: Time.parse('2016-05-31T12:34:56Z').utc,
        message: 'foobar'
      }
      expect(subject.send(:_format, hash)).to eq(
        "app=\"FooService\" severity=\"ERROR\" time=\"2016-05-31T12:34:56.000+0000\" correlation_id=\"CORRELATIONID\" request_id=\"REQUESTID\" parent_request_id=\"\" foobar#{described_class::NEW_LINE}"
      )
    end
  end

  describe '#context_tags' do
    it 'gets correlation id from the request auditing context' do
      expect(Rack::RequestAuditing::ContextSingleton)
        .to receive(:correlation_id)
      subject.send(:context_tags)
    end

    it 'gets request id from the request auditing context' do
      expect(Rack::RequestAuditing::ContextSingleton)
        .to receive(:request_id)
      subject.send(:context_tags)
    end

    it 'gets parent request id from the request auditing context' do
      expect(Rack::RequestAuditing::ContextSingleton)
        .to receive(:parent_request_id)
      subject.send(:context_tags)
    end

    it 'returns the context tags' do
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:correlation_id).and_return('correlation_id')
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:request_id).and_return('request_id')
      allow(Rack::RequestAuditing::ContextSingleton)
        .to receive(:parent_request_id).and_return('parent_request_id')
      expect(subject.send(:context_tags)).to eq(
        {
          correlation_id: 'correlation_id',
          request_id: 'request_id',
          parent_request_id: 'parent_request_id'
        }
      )
    end
  end

  describe '#format_tag' do
    it 'formats the tag value' do
      tag_value = double('tag value')
      expect(subject).to receive(:format_tag_value).with(tag_value)
      subject.send(:format_tag, 'tag_name', tag_value)
    end

    it 'returns the formatted tag' do
      tag_value = double('tag value')
      allow(subject).to receive(:format_tag_value).with(tag_value)
        .and_return("\"formatted tag value\"")
      expect(subject.send(:format_tag, 'tag_name', tag_value))
        .to eq("tag_name=\"formatted tag value\"")
    end
  end

  describe '#format_tag_value' do
    context 'when the tag value is not nil' do
      it 'returns the value wrapped by quotes' do
        expect(subject.send(:format_tag_value, 'bar')).to eq '"bar"'
      end
    end

    context 'when the tag value is nil' do
      it 'returns blank string' do
        expect(subject.send(:format_tag_value, nil)).to eq "\"\""
      end
    end
  end
end
