defmodule GuardianWeb.Api.V1.ErrorView do
  use GuardianWeb, :view
  alias GuardianWeb.Api.V1.ErrorView

  def render("index.json", %{errors: errors}) do
    %{data: render_many(errors, ErrorView, "error.json")}
  end

  def render("show.json", %{error: error}) do
    %{data: render_one(error, ErrorView, "error.json")}
  end

  def render("error.json", %{error: error}) do
    %{
      id: error.id,
      title: error.title,
      description: error.description,
      severity: error.severity,
      assigned_developer: error.assigned_developer
    }
  end
end
