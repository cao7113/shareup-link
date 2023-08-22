defmodule Slink do
  @moduledoc """
  Slink keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def config_info do
    Application.get_env(:slink, :config_info)
  end

  def build_env, do: config_info()[:build_env]

  def assert_dev!, do: assert_env!([:dev])

  def assert_env!(target_envs, env \\ build_env()) when is_list(target_envs) do
    unless env in target_envs do
      raise "current env(#{env}) not in targets: #{target_envs |> inspect}"
    end
  end
end
