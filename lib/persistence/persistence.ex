defmodule Jobchecker.Persistence do
  def init() do
    nodes = [ node() ]
    Memento.stop
    Memento.Schema.create(nodes)
    Memento.start
    case Memento.Table.create(Jobchecker.Postings, disc_copies: nodes) do
      :ok -> :ok
      {:error, {:already_exists, Jobchecker.Postings}} -> :ok
      otherwise -> raise otherwise
    end

    case Memento.Table.create(Jobchecker.Failures, disc_copies: nodes) do
      :ok -> :ok
      {:error, {:already_exists, Jobchecker.Failures}} -> :ok
      otherwise -> raise otherwise
    end
  end

  def insert_jobs(company, jobs) do
    Memento.transaction! fn ->
      Memento.Query.write(%Jobchecker.Postings{company: company, jobs: jobs})
    end
  end

  def delete_jobs(company) do
    Memento.transaction! fn ->
      Memento.Query.delete(Jobchecker.Postings, company)
    end
  end

  def retrieve_jobs(company) do
    Memento.transaction! fn ->
      Memento.Query.read(Jobchecker.Postings, company)
    end
  end

  def insert_failures(%Jobchecker.Failures{} = x) do
    Memento.transaction! fn ->
      Memento.Query.write(x)
    end
  end

  def insert_failures(company, failures, date) do
    Memento.transaction! fn ->
      Memento.Query.write(%Jobchecker.Failures{company: company, failures: failures, timestamp: date})
    end
  end

  def retrieve_failures(company) do
    Memento.transaction! fn ->
      Memento.Query.read(Jobchecker.Failures, company)
    end
  end

  def clear_failure(company) do
    Memento.transaction! fn ->
      Memento.Query.delete(Jobchecker.Failures, company)
    end
  end

  def clear() do
    Memento.Table.clear(Jobchecker.Postings)
    Memento.Table.clear(Jobchecker.Failures)
  end
end
