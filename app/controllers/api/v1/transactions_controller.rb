module Api
  module V1
    class TransactionsController < BaseController
      def index
        render json: Transaction.all.map(&:as_json).to_json
      end

      def populate
        service = Api::V1::TransactionsService.new(nil, omniauth: request.env['omniauth.auth'])
        service.execute!

        if service.success?
          render json: { status: :ok }
        else
          render json: { status: :unprocessable_entity }
        end
      end
    end
  end
end
