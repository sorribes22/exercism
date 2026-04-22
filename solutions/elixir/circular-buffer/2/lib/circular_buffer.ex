defmodule CircularBuffer do
  @moduledoc """
  An API to a stateful process that fills and empties a circular buffer
  """
  use GenServer

  # Structure definition and functions
  @type t :: %__MODULE__{
    buffer: :array.array(),
    first: non_neg_integer(),
    next: non_neg_integer(),
    count: non_neg_integer(),
    size: pos_integer()
  }

  defstruct [
    buffer: nil,
    first: 0,
    next: 0,
    count: 0,
    size: 0
  ]

  def full?(circular_buffer), do: circular_buffer.count == circular_buffer.size
  def b_write(circular_buffer, item, overwrite? \\ false) do
    full? = full?(circular_buffer)

    if full? and not overwrite? do
      {:error, :full}
    else
      new_first = if full?, do: rem(circular_buffer.first + 1, circular_buffer.size), else: circular_buffer.first
      new_count = if full?, do: circular_buffer.count, else: circular_buffer.count + 1

      {:ok, %{circular_buffer |
          buffer: :array.set(circular_buffer.next, item, circular_buffer.buffer),
          first: new_first,
          next: rem(circular_buffer.next + 1, circular_buffer.size),
          count: new_count
        }
      }
    end
  end

  # Server definition
  @impl true
  @spec init(integer()) :: {:ok, t()}
  def init(capacity) do
    {:ok, %__MODULE__{
      buffer: :array.new(capacity, default: nil),
      size: capacity
    }}
  end

  @impl true
  def handle_call(:read, _from, %__MODULE__{count: 0} = state) do
    {:reply, {:error, :empty}, state}
  end

  def handle_call(:read, _from, state) do
    item = :array.get(state.first, state.buffer)
    :array.set(state.first, nil, state.buffer)
    state = %{state |
      first: rem(state.first + 1, state.size),
      count: state.count - 1
    }
    {:reply, {:ok, item}, state}
  end

  def handle_call({:write, item}, _from, state) do
    case b_write(state, item) do
      {:ok, new_state} -> {:reply, {:ok, item}, new_state}
      error -> {:reply, error, state}
    end

  end

  def handle_call({:overwrite, item}, _from, state) do
    {_, new_state} = b_write(state, item, true)

    {:reply, {:ok, item}, new_state}
  end

  @impl true
  def handle_cast(:clear, state) do
    state = %{state |
      buffer: :array.new(state.size),
      first: 0,
      next: 0,
      count: 0,
    }
    {:noreply, state}
  end

  @doc """
  Create a new buffer of a given capacity
  """
  @spec new(capacity :: integer) :: {:ok, pid}
  def new(capacity) do
    GenServer.start(__MODULE__, capacity)
  end

  @doc """
  Read the oldest entry in the buffer, fail if it is empty
  """
  @spec read(buffer :: pid) :: {:ok, any} | {:error, atom}
  def read(buffer) do
    GenServer.call(buffer, :read)
  end

  @doc """
  Write a new item in the buffer, fail if is full
  """
  @spec write(buffer :: pid, item :: any) :: :ok | {:error, atom}
  def write(buffer, item) do
    case GenServer.call(buffer, {:write, item}) do
      {:ok, _} -> :ok
      error -> error
    end
  end

  @doc """
  Write an item in the buffer, overwrite the oldest entry if it is full
  """
  @spec overwrite(buffer :: pid, item :: any) :: :ok
  def overwrite(buffer, item) do
    GenServer.call(buffer, {:overwrite, item})
  end

  @doc """
  Clear the buffer
  """
  @spec clear(buffer :: pid) :: :ok
  def clear(buffer) do
    GenServer.cast(buffer, :clear)
  end
end
