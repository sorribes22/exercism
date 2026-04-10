defmodule DancingDots.Animation do
  @type dot :: DancingDots.Dot.t()
  @type opts :: keyword
  @type error :: any
  @type frame_number :: pos_integer

  @callback init(opts()) :: {:ok, opts()} | {:error, error()}
  @callback handle_frame(dot(), frame_number(), opts()) :: dot()

  defmacro __using__(_) do
    quote do
      @behaviour DancingDots.Animation
      def init(opts), do: {:ok, opts}
      defoverridable init: 1
    end
  end
end

defmodule DancingDots.Flicker do
  use DancingDots.Animation

  def handle_frame(dot, frame_number, _opts) when rem(frame_number, 4) == 0, do: %{dot | opacity: dot.opacity/ 2}
  def handle_frame(dot, _frame_number, _opts), do: dot
end

defmodule DancingDots.Zoom do
  use DancingDots.Animation

  def init(opts = [velocity: velocity]) when is_number(velocity), do: super(opts)
  def init([velocity: velocity]), do: {:error, "The :velocity option is required, and its value must be a number. Got: \"#{velocity}\""}
  def init(_), do: {:error, "The :velocity option is required, and its value must be a number. Got: nil"}
  def handle_frame(dot, frame_number, [velocity: velocity]) when is_number(velocity),
    do: %{dot | radius: dot.radius + (frame_number - 1) * velocity}
  def handle_frame(_, _, _),
    do: {:error, "The :velocity option is required, and its value must be a number. Got: nil"}

end
