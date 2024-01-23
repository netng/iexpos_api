defmodule IexposApiWeb.TestControllerTest do
  use IexposApiWeb.ConnCase

  import IexposApi.TestsFixtures

  alias IexposApi.Tests.Test

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tests", %{conn: conn} do
      conn = get(conn, ~p"/api/tests")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create test" do
    test "renders test when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tests", test: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tests/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tests", test: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update test" do
    setup [:create_test]

    test "renders test when data is valid", %{conn: conn, test: %Test{id: id} = test} do
      conn = put(conn, ~p"/api/tests/#{test}", test: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tests/#{id}")

      assert %{
               "id" => ^id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, test: test} do
      conn = put(conn, ~p"/api/tests/#{test}", test: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete test" do
    setup [:create_test]

    test "deletes chosen test", %{conn: conn, test: test} do
      conn = delete(conn, ~p"/api/tests/#{test}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tests/#{test}")
      end
    end
  end

  defp create_test(_) do
    test = test_fixture()
    %{test: test}
  end
end
