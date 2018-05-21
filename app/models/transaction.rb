class Transaction < ApplicationRecord
  belongs_to :account

  serialize :details

  validates_uniqueness_of :message_uid
end
