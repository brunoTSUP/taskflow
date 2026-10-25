require "test_helper"

class HealthControllerTest < ActionDispatch::IntegrationTest
  test "returns ok when database is accessible" do
    get "/health"

    assert_response :ok

    response_body = response.parsed_body
    assert_equal "ok", response_body[:status]
    assert_equal "connected", response_body[:database]
  end

  test "returns service unavailable when database query fails" do
    mock_connection = Object.new

    mock_connection.define_singleton_method(:execute, ->(sql) {
      raise ActiveRecord::StatementInvalid.new("PG::SyntaxError: ERROR")
    })

    ActiveRecord::Base.stub(:connection, mock_connection) do
      get "/health"
    end

    assert_response :service_unavailable

    response_body = response.parsed_body
    assert_equal "error", response_body["status"]
    assert_equal "unavailable", response_body["database"]
  end
end
