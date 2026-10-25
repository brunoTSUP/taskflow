class HealthController < ApplicationController
  def show
    ActiveRecord::Base.connection.execute("SELECT 1")

    render json: { status: "ok", database: "connected" }, status: :ok

  rescue ActiveRecord::ConnectionNotEstablished,
         ActiveRecord::ConnectionTimeoutError,
         ActiveRecord::StatementInvalid,
         PG::Error
      render json: { status: "error", database: "unavailable" },
             status: :service_unavailable
  end
end
