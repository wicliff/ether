defmodule Utils do
  @moduledoc """
  Utilities and useful functions for the application
  """

  @doc """
  Converts the value of a Hexadecimal number to an integer
  """
  @spec hex_to_int(<<_::16, _::_*8>>) :: integer
  def hex_to_int(hex) do
    "0x" <> hex_string = hex
    {int_number, _} = Integer.parse(hex_string, 16)
    int_number
  end

  def show_status(true),
    do:
      ~s(<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6 text-green-300">
  <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
</svg>)

  def show_status(false),
    do:
      ~s(<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-6 h-6">
  <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
</svg>)
end
