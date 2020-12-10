defmodule GuardianWeb.Queue do
  use GenServer
  require Logger
  alias AMQP.Connection

  #TODO Check env variables
  @connection_options [host: "localhost", port: 5672, virtual_host: "/", username: "user", password: "password", name: "rabbitmq"]
  @reconnect_interval 10_000

  def start_link(opts \\ [name: __MODULE__]) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def init(_) do
    send(self(), :connect)
    {:ok, nil}
  end

  def get_connection do
    case GenServer.call(__MODULE__, :get) do
      nil -> {:error, :not_connected}
      conn -> {:ok, conn}
    end
  end

  def handle_call(:get, _, conn) do
    {:reply, conn, conn}
  end

  def handle_info(:connect, conn) do
    case Connection.open(@connection_options) do
      {:ok, conn} ->
        # Get notifications when the connection goes down
        Process.monitor(conn.pid)
        {:noreply, conn}

      {:error, _} ->
        Logger.error("Failed to connect #{@host}. Reconnecting later...")
        # Retry later
        Process.send_after(self(), :connect, @reconnect_interval)
        {:noreply, nil}
    end
  end

  def handle_info({:DOWN, _, :process, _pid, reason}, _) do
    # Stop GenServer. Will be restarted by Supervisor.
    {:stop, {:connection_lost, reason}, nil}
  end

  def publish(topic, body) do
    case Connection.open(@connection_options) do
      {:ok, connection} ->
        {:ok, channel} = AMQP.Channel.open(connection)
        AMQP.Exchange.declare(channel, "topics_guardian", :topic)
        AMQP.Basic.publish(channel, "topics_guardian", topic, body)
      {:error, _} ->
        Logger.error("Failed to connect #{@connection_options}. Reconnecting later...")
        # Retry later
        Process.send_after(self(), :connect, @reconnect_interval)
        {:noreply, nil}
    end
  end
end