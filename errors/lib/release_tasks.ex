defmodule Guardian.ReleaseTasks do
  def migrate() do
    IO.puts("***** RUNNING MIGRATIONS *****")
    {:ok, _} = Application.ensure_all_started(:guardian)

    path = Application.app_dir(:guardian, "priv/repo/migrations")

    Ecto.Migrator.run(Guardian.Repo, path, :up, all: true)
    IO.puts("***** FINISHED MIGRATIONS *****")
  end
end
