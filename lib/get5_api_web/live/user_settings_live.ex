defmodule Get5ApiWeb.UserSettingsLive do
  use Get5ApiWeb, :live_view

  alias Get5Api.Accounts

  def render(assigns) do
    ~H"""
    <div class="mb-8">
      <h1 class="text-2xl font-bold text-zinc-900 dark:text-zinc-100">Account settings</h1>
      <p class="text-sm text-zinc-500 dark:text-zinc-400 mt-1">
        Manage your login details and security
      </p>
    </div>

    <div class="space-y-8">
      <section class="rounded-lg border border-zinc-200 dark:border-zinc-700 bg-white dark:bg-zinc-800/40 overflow-hidden">
        <div class="grid md:grid-cols-3 divide-y md:divide-y-0 md:divide-x divide-zinc-200 dark:divide-zinc-700">
          <div class="p-6 md:col-span-1">
            <h2 class="font-semibold text-zinc-900 dark:text-zinc-100">Email address</h2>
            <p class="text-sm text-zinc-500 dark:text-zinc-400 mt-2">
              Used for sign-in. A confirmation link will be sent to the new address before the change takes effect.
            </p>
            <p class="text-xs text-zinc-500 dark:text-zinc-400 mt-4 font-mono break-all">
              Current: {@current_email}
            </p>
          </div>

          <div class="p-6 md:col-span-2">
            <.simple_form
              for={@email_form}
              id="email_form"
              phx-submit="update_email"
              phx-change="validate_email"
            >
              <.input field={@email_form[:email]} type="email" label="New email" required />
              <.input
                field={@email_form[:current_password]}
                name="current_password"
                id="current_password_for_email"
                type="password"
                label="Current password"
                value={@email_form_current_password}
                required
              />
              <:actions>
                <.button phx-disable-with="Changing...">Change email</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </section>

      <section class="rounded-lg border border-zinc-200 dark:border-zinc-700 bg-white dark:bg-zinc-800/40 overflow-hidden">
        <div class="grid md:grid-cols-3 divide-y md:divide-y-0 md:divide-x divide-zinc-200 dark:divide-zinc-700">
          <div class="p-6 md:col-span-1">
            <h2 class="font-semibold text-zinc-900 dark:text-zinc-100">Password</h2>
            <p class="text-sm text-zinc-500 dark:text-zinc-400 mt-2">
              Choose a strong password. You'll be signed in with the new password after changing.
            </p>
          </div>

          <div class="p-6 md:col-span-2">
            <.simple_form
              for={@password_form}
              id="password_form"
              action={~p"/users/log_in?_action=password_updated"}
              method="post"
              phx-change="validate_password"
              phx-submit="update_password"
              phx-trigger-action={@trigger_submit}
            >
              <.input
                field={@password_form[:email]}
                type="hidden"
                id="hidden_user_email"
                value={@current_email}
              />
              <.input
                field={@password_form[:password]}
                type="password"
                label="New password"
                required
              />
              <.input
                field={@password_form[:password_confirmation]}
                type="password"
                label="Confirm new password"
              />
              <.input
                field={@password_form[:current_password]}
                name="current_password"
                type="password"
                label="Current password"
                id="current_password_for_password"
                value={@current_password}
                required
              />
              <:actions>
                <.button phx-disable-with="Changing...">Change password</.button>
              </:actions>
            </.simple_form>
          </div>
        </div>
      </section>
    </div>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end
end
