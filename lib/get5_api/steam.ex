defmodule Get5Api.Steam do
  alias Get5Api.Steam.Profile
  alias Get5Api.Steam.SteamID

  def fetch_profile(steam_id) do
    Profile.fetch(steam_id)
  end

  def steam_id_to_steamID64(steam_id) do
    SteamID.steam_id_to_community_id(steam_id)
  end

  def is_steamID64?(steam_id) do
    SteamID.is_steam64?(steam_id)
  end
end
