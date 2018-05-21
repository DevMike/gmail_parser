module Api
  module V1
    class BaseController < ApplicationController

      rescue_from ActionController::ParameterMissing, with: :unprocessable_entity
      rescue_from Gmail::Client::AuthorizationError, with: :user_not_authorized

      private def respond_with(object, using:)
        render json: (object.is_a?(Enumerable) ? using.json_list(object) : using.new(object).as_json)
      end

      private def respond_error(status, object)
        render json: Errors.new(object).as_json, status: status
      end

      private def respond_exception(status, exception)
        respond_error status, OpenStruct.new(errors: { base: exception })
      end

      private def not_found(exception)
        respond_exception :not_found, exception
      end

      private def unprocessable_entity(exception)
        respond_exception :unprocessable_entity, exception
      end

      private def render_service_response(success, result, presenter)
        if success || result == []
          respond_with result, using: presenter
        else
          respond_error :unprocessable_entity, result
        end
      end

      private def serve(object_name, present_with:, service: nil)
        service.execute!
        object = service.public_send(result_object_name)
        render_service_response(service.success?, object, present_with)
      end

      private def user_not_authorized
        head :unauthorized
      end
    end
  end
end
