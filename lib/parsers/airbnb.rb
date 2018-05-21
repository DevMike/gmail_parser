module Parsers
  class Airbnb < Base
    def service_name
      'airbnb'
    end

    def populate_transactions
      billing_emails.map do |mes|
        doc = Nokogiri::HTML(mes.html_part.body.decoded)
        details = booking_details(doc)
        Transaction.create(
          value_cents: value_cents(doc),
          purchased_at: purchased_at(doc),
          message_uid: mes.message_id,
          details: {
            location: details[2],
            appartments: details[3],
            nights: details[5]
          },
          account: @account,
          service: service_name
        )
      end
    end

    private def booking_details(doc)
      doc.xpath("//div[contains(@class, 'section')][3]").css('div:first td').
        select.each_with_index { |_, i| i.odd? }.
        map{|v| v.text.gsub(/\s{2,}|\r\n/, '') }
    end

    private def value_cents(doc)
      doc.xpath("//div[contains(@class, 'section')][6]").css('div:first td').last.
        text[/[$](\d{1,3}(,\d{3})*(\.\d*)?)?/].gsub(/,/, '')[1..-1].to_f*100
    end

    private def purchased_at(doc)
      DateTime.parse(doc.xpath("//div[contains(@class, 'section')][5]").first.text)
    end
  end
end
