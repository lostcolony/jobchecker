defmodule Jobchecker do
  @moduledoc """
  Documentation for `Jobchecker`.
  """


  def init({name, func, args}, return_pid) do
    send(return_pid, {name, func.(args)})
  end
end
