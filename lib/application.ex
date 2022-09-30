defmodule Jobchecker.Application do
  use Application

  def start(_, _) do
    Orchestration.run()
  end
end
