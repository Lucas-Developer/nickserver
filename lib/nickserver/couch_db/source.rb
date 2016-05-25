#
# This class allows querying couch for public keys.
#
require 'nickserver/couch_db/response'

module Nickserver::CouchDB
  class Source

    VIEW = '/_design/Identity/_view/pgp_key_by_email'

    def initialize(adapter)
      @adapter = adapter
    end

    def query(nick)
      adapter.get VIEW, query: query_for(nick) do |status, body|
        yield Response.new nick, status: status, body: body
      end
    end

    protected

    def query_for(nick)
      { reduce: "false", key: "\"#{nick}\"" }
    end

    def adapter
      @adapter
      # Nickserver::Adapters::Http.new(config)
    end

    attr_reader :config
  end
end
