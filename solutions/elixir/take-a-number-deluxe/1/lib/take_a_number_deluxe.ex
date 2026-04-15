defmodule TakeANumberDeluxe do
  # Client API
  use GenServer

  @spec start_link(keyword()) :: {:ok, pid()} | {:error, atom()}
  def start_link(opts) when is_list(opts) do
    min_number = Keyword.get(opts, :min_number)
    max_number = Keyword.get(opts, :max_number)
    auto_shutdown_timeout = Keyword.get(opts, :auto_shutdown_timeout, :infinity)

    GenServer.start_link(__MODULE__, TakeANumberDeluxe.State.new(min_number, max_number, auto_shutdown_timeout))
  end

  @spec report_state(pid()) :: TakeANumberDeluxe.State.t()
  def report_state(machine) do
    GenServer.call(machine, :state)
  end

  @spec queue_new_number(pid()) :: {:ok, integer()} | {:error, atom()}
  def queue_new_number(machine) do
    GenServer.call(machine, :queue_new_number)
  end

  @spec serve_next_queued_number(pid(), integer() | nil) :: {:ok, integer()} | {:error, atom()}
  def serve_next_queued_number(machine, priority_number \\ nil) do
    GenServer.call(machine, {:serve_next_queued_number, priority_number})
  end

  @spec reset_state(pid()) :: :ok
  def reset_state(machine) do
    GenServer.cast(machine, :reset)
  end

  # Server callbacks

  @impl GenServer
  def init({:ok, state}), do: {:ok, state, state.auto_shutdown_timeout}
  @impl GenServer
  def init({:error, :invalid_configuration}), do: {:stop, :invalid_configuration}
  @impl GenServer
  def handle_call(:state, _from, state), do: {:reply, state, state, state.auto_shutdown_timeout}
  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}
      {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}
    end
  end
  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, new_number, new_state} -> {:reply, {:ok, new_number}, new_state, state.auto_shutdown_timeout}
      {:error, error} -> {:reply, {:error, error}, state, state.auto_shutdown_timeout}
    end
  end
  @impl GenServer
  def handle_cast(:reset, state) do
    {_, state} = TakeANumberDeluxe.State.new(state.min_number, state.max_number, state.auto_shutdown_timeout)
    {:noreply, state, state.auto_shutdown_timeout}
  end
  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state.auto_shutdown_timeout}
  @impl GenServer
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}

  # Please implement the necessary callbacks
end
