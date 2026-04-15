# Use the Plot struct as it is provided
defmodule Plot do
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  def start(_opts \\ []) do
    Agent.start(fn -> [plots: [], next_id: 1] end)
  end

  def list_registrations(pid) do
    Agent.get(pid, fn state -> state[:plots] end)
  end

  def register(pid, register_to) do
    Agent.get_and_update(pid, fn state ->
      new_plot = %Plot{plot_id: state[:next_id], registered_to: register_to}

      new_state = [
        plots: [new_plot | state[:plots]],
        next_id: state[:next_id] + 1
      ]

      {new_plot, new_state}
    end)
  end

  def release(pid, plot_id) do
    Agent.update(pid, fn state ->
      [
        plots: Enum.reject(state[:plots], fn %Plot{plot_id: id} -> id == plot_id end),
        next_id: state[:next_id]
      ]
    end)
  end

  def get_registration(pid, plot_id) do
    plot =
      Agent.get(pid, fn state -> state[:plots] end)
      |> Enum.filter(fn %Plot{plot_id: id} -> id == plot_id end)
      |> Enum.to_list()
      |> List.first()

    if plot,
    do: plot,
    else: {:not_found, "plot is unregistered"}
  end
end
