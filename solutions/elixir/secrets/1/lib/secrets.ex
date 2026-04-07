import Bitwise

defmodule Secrets do
  def secret_add(secret) do
    fn param ->
      param + secret
    end
  end

  def secret_subtract(secret) do
    &(&1 - secret)
  end

  def secret_multiply(secret) do
    &(&1 * secret)
  end

  def secret_divide(secret) do
    # / -> float division
    # div -> integer division

    # First iteration:
    #   &(&1 / secret)

    # Second iteration:
    &(div(&1, secret))
  end

  def secret_and(secret) do
    &(band(&1, secret))
  end

  def secret_xor(secret) do
    &(bxor(&1, secret))
  end

  def secret_combine(secret_function1, secret_function2) do
    fn param ->
      # First iteration:
      #   first = secret_function1.(param)
      #   secret_function2.(first)

      # Second iteration:
      #   secret_function2.(secret_function1.(param))

      # Third iteration:
      param |> secret_function1.() |> secret_function2.()
    end
  end
end
