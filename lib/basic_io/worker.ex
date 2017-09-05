defmodule BasicIo.Worker do
  use GenServer

  @light_sensor 1 # Port A1
  @led 3          # Port D3

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def init(state) do
    GrovePi.Digital.set_pin_mode(@led, :output)
    send(self(), :check_sensor)
    {:ok, state}
  end

  def handle_info(:check_sensor, state) do
    light = GrovePi.Analog.read(@light_sensor)
    led_value = if light > 200, do: 0, else: 1
    GrovePi.Digital.write(@led, led_value)

    Process.send_after(self(), :check_sensor, 100)
    {:noreply, state}
  end
end
