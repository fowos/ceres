defmodule CeresWeb.Api.Localizers.LocalizersJSON do
  alias Ceres.Localizers.Localizer

  def index(%{localizers: localizers}) do
    %{data: for(localizer <- localizers, do: data(localizer))}
  end

  def show(%{localizer: localizer}) do
    %{data: data(localizer)}
  end

  defp data(%Localizer{} = localizer) do
    %{
      id: localizer.id,
      name: localizer.name,
      description: localizer.description
    }
  end
end
