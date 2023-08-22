defmodule SlinkWeb.TestLive do
  use SlinkWeb, :live_view
  require Logger

  #   <.link
  #   phx-click={JS.push("test_click", value: %{myvar1: "my value1"})}
  #   phx-value-var1="value1"
  #   phx-value-var2="value2"
  # >
  #   Test Click
  # </.link>
  # <div><%= @test_var %></div>

  # <h2>Test Key</h2>
  # <.input
  #   id="the-input"
  #   name="test-input"
  #   phx-keydown="keydown"
  #   value=""
  #   placeholder="keydown something here"
  # />
  # <div><%= @keydown %></div>
  # <.button phx-dispatch={JS.dispatch("abc")}>Focus input</.button>

  # <.test_modal />

  # <.input name="my-input" errors={["oh no!"]} value="" />

  # <div phx-mounted={JS.transition("animate-ping", time: 500)}>
  #   Test phx-mounted animation
  # </div>

  @impl true
  def render(assigns) do
    Logger.info("==render call #{DateTime.utc_now()}")

    ~H"""
    ========================
    """
  end

  @impl true
  def mount(params, session, socket) do
    Logger.info("mount call: #{%{params: params, session: session, socket: socket} |> inspect}")
    {:ok, socket}
  end

  @impl true
  def handle_params(params, uri, socket) do
    Logger.info("handle_params call: #{%{params: params, uri: uri, socket: socket} |> inspect}")

    {:noreply,
     socket
     |> assign(:test_var, "init value")
     |> assign(:keydown, "")}
  end

  @impl true
  def handle_event("test_click", params, socket) do
    Logger.info("test click with params: #{params |> inspect}")

    {:noreply,
     socket
     |> assign(:test_var, "clicked last time #{Timex.now()}")}
  end

  @impl true
  def handle_event("keydown", %{"key" => key} = params, socket) do
    Logger.info("key-down with params: #{params |> inspect}")

    {:noreply,
     socket
     |> assign(:keydown, "#{key} keydown")}
  end

  alias Phoenix.LiveView.JS

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(transition: "fade-out", to: "#modal")
    |> JS.hide(transition: "fade-out-scale", to: "#modal-content")
  end

  def test_modal(assigns) do
    ~H"""
    <div id="modal" class="phx-modal" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content"
        phx-click-away={hide_modal()}
        phx-window-keydown={hide_modal()}
        phx-key="escape"
      >
        <button class="phx-modal-close" phx-click={hide_modal()}>✖</button>
        <p>
          Test modal
          hhhh
          hhhhhh
          😄
        </p>
      </div>
    </div>
    """
  end
end
