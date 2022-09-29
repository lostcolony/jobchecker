defmodule Persistence do
  def init() do
    nodes = [ node() ]
    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start
    case Memento.Table.create(Postings, disc_copies: nodes) do
      :ok -> :ok
      {:error, {:already_exists, Postings}} -> :ok
      otherwise -> raise otherwise
    end
  end

  def insert_jobs(company, jobs) do
    Memento.transaction! fn ->
      Memento.Query.write(%Postings{company: company, jobs: jobs})
    end
  end

  def retrieve_jobs(company) do
    Memento.transaction! fn ->
      Memento.Query.read(Postings, company)
    end
  end

  def clear() do
    Memento.Table.clear(Postings)
  end
end
