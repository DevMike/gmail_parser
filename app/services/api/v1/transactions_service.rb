module Api
  module V1
    class TransactionsService < ApplicationService
      attr_accessor :omniauth

      def execute!
        super do
          Gmail.connect!(:xoauth2,
                         omniauth.info.email,
                         omniauth.credentials.token)
          account = Account.find_or_create_by!(email: omniauth.info.email)
          ParseEmailsJob.perform_later(account.id, omniauth.credentials.token)
          success!
        end
      end
    end
  end
end
