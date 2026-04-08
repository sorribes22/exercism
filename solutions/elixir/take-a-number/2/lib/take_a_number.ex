defmodule TakeANumber do
  def start() do
    spawn(fn -> consume_loop(0) end)
  end

  defp consume_loop(accum) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, accum)
        consume_loop(accum)
      {:take_a_number, sender_pid} ->
        new_state = accum + 1
        send(sender_pid, new_state)
        consume_loop(new_state)
      :stop -> nil
      _ -> consume_loop(accum)
    end
  end
end
