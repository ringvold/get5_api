defmodule Get5ApiWeb.Layouts do
  use Get5ApiWeb, :html

  embed_templates "layouts/*"

  def active_section(nil), do: nil

  def active_section(path) when is_binary(path) do
    cond do
      String.starts_with?(path, "/teams") -> :teams
      String.starts_with?(path, "/matches") -> :matches
      String.starts_with?(path, "/game_servers") -> :servers
      true -> nil
    end
  end

  attr :navigate, :string, required: true
  attr :active, :boolean, default: false
  slot :inner_block, required: true

  def nav_link(assigns) do
    ~H"""
    <.link
      navigate={@navigate}
      aria-current={if @active, do: "page"}
      class={[
        "relative px-3 py-1.5 text-sm font-medium transition",
        if(@active,
          do:
            "text-zinc-900 dark:text-zinc-100 after:absolute after:left-3 after:right-3 after:-bottom-[14px] after:h-0.5 after:bg-zinc-900 dark:after:bg-zinc-100",
          else: "text-zinc-500 dark:text-zinc-400 hover:text-zinc-900 dark:hover:text-zinc-100"
        )
      ]}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end
end
