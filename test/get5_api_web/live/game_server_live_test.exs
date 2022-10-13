defmodule Get5ApiWeb.GameServerLiveTest do
  use Get5ApiWeb.ConnCase

  import Phoenix.LiveViewTest
  import Get5Api.GameServersFixtures

  @create_attrs %{host: "some host", name: "some name", port: "some port", rcon_password: "some rcon_password"}
  @update_attrs %{host: "some updated host", name: "some updated name", port: "some updated port", rcon_password: "some updated rcon_password"}
  @invalid_attrs %{host: nil, name: nil, port: nil, rcon_password: nil}

  defp create_game_server(_) do
    game_server = game_server_fixture()
    %{game_server: game_server}
  end

  describe "Index" do
    setup [:create_game_server]

    test "lists all game_servers", %{conn: conn, game_server: game_server} do
      {:ok, _index_live, html} = live(conn, Routes.game_server_index_path(conn, :index))

      assert html =~ "Listing Game servers"
      assert html =~ game_server.host
    end

    test "saves new game_server", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.game_server_index_path(conn, :index))

      assert index_live |> element("a", "New Game server") |> render_click() =~
               "New Game server"

      assert_patch(index_live, Routes.game_server_index_path(conn, :new))

      assert index_live
             |> form("#game_server-form", game_server: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#game_server-form", game_server: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.game_server_index_path(conn, :index))

      assert html =~ "Game server created successfully"
      assert html =~ "some host"
    end

    test "updates game_server in listing", %{conn: conn, game_server: game_server} do
      {:ok, index_live, _html} = live(conn, Routes.game_server_index_path(conn, :index))

      assert index_live |> element("#game_server-#{game_server.id} a", "Edit") |> render_click() =~
               "Edit Game server"

      assert_patch(index_live, Routes.game_server_index_path(conn, :edit, game_server))

      assert index_live
             |> form("#game_server-form", game_server: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#game_server-form", game_server: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.game_server_index_path(conn, :index))

      assert html =~ "Game server updated successfully"
      assert html =~ "some updated host"
    end

    test "deletes game_server in listing", %{conn: conn, game_server: game_server} do
      {:ok, index_live, _html} = live(conn, Routes.game_server_index_path(conn, :index))

      assert index_live |> element("#game_server-#{game_server.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#game_server-#{game_server.id}")
    end
  end

  describe "Show" do
    setup [:create_game_server]

    test "displays game_server", %{conn: conn, game_server: game_server} do
      {:ok, _show_live, html} = live(conn, Routes.game_server_show_path(conn, :show, game_server))

      assert html =~ "Show Game server"
      assert html =~ game_server.host
    end

    test "updates game_server within modal", %{conn: conn, game_server: game_server} do
      {:ok, show_live, _html} = live(conn, Routes.game_server_show_path(conn, :show, game_server))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Game server"

      assert_patch(show_live, Routes.game_server_show_path(conn, :edit, game_server))

      assert show_live
             |> form("#game_server-form", game_server: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#game_server-form", game_server: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.game_server_show_path(conn, :show, game_server))

      assert html =~ "Game server updated successfully"
      assert html =~ "some updated host"
    end
  end
end
