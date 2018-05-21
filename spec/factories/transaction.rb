FactoryBot.define do
  factory :transaction, class: Transaction do
    account
    service 'airbnb'
    value_cents 100500
    purchased_at "2017-12-06 21:19:31"
    message_uid "1586070995090214910"
    details { { location: "somewhere", appartments: "apartments", nights: "3"} }
  end
end
