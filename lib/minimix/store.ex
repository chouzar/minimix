defmodule Minimix.Store do
  use GenServer

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    table_pid = :ets.new(Minimix.Store.ETS, [])

    {:ok, table_pid}
  end

  @impl true
  def handle_call({:get, key}, _from, table_pid) do
    value =
      case :ets.lookup(table_pid, key) do
        [] -> nil
        [{_key, value}] -> value
      end

    {:reply, value, table_pid}
  end

  def handle_call(:all, _from, table_pid) do
    all =
      :ets.match(table_pid, :"$1")
      |> Enum.flat_map(fn x -> x end)

    {:reply, all, table_pid}
  end

  @impl true
  def handle_cast({:put, key, value}, table_pid) do
    :ets.insert(table_pid, {key, value})

    {:noreply, table_pid}
  end

end
