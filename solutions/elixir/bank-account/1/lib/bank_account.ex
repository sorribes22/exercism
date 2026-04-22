defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank account, making it available for further operations.
  """
  @spec open() :: account
  def open() do
    {_, pid} = Agent.start_link(fn -> 0 end)
    pid
  end

  @doc """
  Close the bank account, making it unavailable for further operations.
  """
  @spec close(account) :: any
  def close(account) do
    Agent.stop(account)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer | {:error, :account_closed}
  def balance(account) do
    if Process.alive?(account) do
      Agent.get(account, &(&1))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Add the given amount to the account's balance.
  """
  @spec deposit(account, integer) :: :ok | {:error, :account_closed | :amount_must_be_positive}
  def deposit(_, amount) when amount < 0, do: {:error, :amount_must_be_positive}
  def deposit(nil, _), do: {:error, :account_closed}
  def deposit(account, amount) do
    if Process.alive?(account) do
      Agent.update(account, &(&1 + amount))
    else
      {:error, :account_closed}
    end
  end

  @doc """
  Subtract the given amount from the account's balance.
  """
  @spec withdraw(account, integer) ::
          :ok | {:error, :account_closed | :amount_must_be_positive | :not_enough_balance}
  def withdraw(_, amount) when amount < 0, do: {:error, :amount_must_be_positive}
  def withdraw(account, amount) do
    if Process.alive?(account) do
      result = Agent.get_and_update(account, fn balance ->
        cond do
          balance >= amount -> {:ok, balance - amount}
          true -> {{:error, :not_enough_balance}, balance}
        end
      end)

      case result do
        {:ok, _} -> :ok
        _ -> result
      end
    else
      {:error, :account_closed}
    end
  end
end
