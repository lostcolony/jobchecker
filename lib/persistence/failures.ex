defmodule Jobchecker.Failures do
  use Memento.Table,
    attributes: [:company, :failures, :timestamp],
    type: :set
end
