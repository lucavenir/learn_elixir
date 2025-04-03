defmodule RefugeWeb.BearHTML do
  use RefugeWeb, :html

  embed_templates "bear_html/*"

  @doc """
  Renders a bear form.

  The form is defined in the template at
  bear_html/bear_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def bear_form(assigns)
end
