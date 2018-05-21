class ParseEmailsJob < ApplicationJob
  queue_as :gmail

  def perform(account_id, omniauth_token)
    account = Account.find(account_id)
    gmail = Gmail.connect!(:xoauth2, account.email, omniauth_token)
    ::Parsers::Airbnb.new(gmail, account).populate_transactions
  end
end
