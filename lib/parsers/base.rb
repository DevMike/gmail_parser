module Parsers
  class Base
    def initialize(gmail, account)
      @gmail = gmail
      @account = account
    end

    def billing_emails
      @billing_emails ||= @gmail.inbox.emails(gm: "from:#{service_name}").select{|m| m.raw_message['X-Template']&.value.to_s.match?('billing_receipt') }
    end

    protected def service_name
      raise NotImplementedError
    end

    protected def populate_transactions
      raise NotImplementedError
    end
  end
end
