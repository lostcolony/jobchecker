defmodule Postings do
  use Memento.Table,
    attributes: [:company, :jobs],
    type: :set
end
