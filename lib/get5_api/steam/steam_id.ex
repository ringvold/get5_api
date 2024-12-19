# Copyright 2015 Eric Entin

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

defmodule Get5Api.Steam.SteamID do
  @moduledoc """
    Various utility functions related to SteamIDs.
  """

  @doc """
  Converts a 64-bit community SteamID to the legacy SteamID format.

  ## Examples

      iex> Get5Api.Steam.SteamID.community_id_to_steam_id(76561197961358433)
      "STEAM_0:1:546352"
  """
  @spec community_id_to_steam_id(pos_integer) :: binary
  def community_id_to_steam_id(community_id) do
    steam_id1 = rem(community_id, 2)
    steam_id2 = community_id - 76_561_197_960_265_728

    if not (steam_id2 > 0) do
      raise "SteamID #{community_id} is too small."
    end

    steam_id2 = div(steam_id2 - steam_id1, 2)

    "STEAM_0:#{steam_id1}:#{steam_id2}"
  end

  @doc """
  Converts a 64-bit community SteamID to the modern SteamID format (aka SteamID 3)

  ## Examples

      iex> Get5Api.Steam.SteamID.community_id_to_steam_id3(76561197961358433)
      "[U:1:1092705]"
  """
  @spec community_id_to_steam_id3(pos_integer) :: binary
  def community_id_to_steam_id3(community_id) do
    if rem(community_id, 2) != 1 do
      raise "SteamID3 only supports public universe"
    end

    steam_id2 = community_id - 76_561_197_960_265_728

    if not (steam_id2 > 0) do
      raise "SteamID #{community_id} is too small."
    end

    "[U:1:#{steam_id2}]"
  end

  def is_steam64?(steam_id) do
    case Integer.parse(steam_id) do
      {_, ""} ->
        String.length(steam_id) == 17 && String.starts_with?(steam_id, "7656119")

      _ ->
        false
    end
  end

  @doc """
  Converts a SteamID as reported by game servers or a SteamID3 to a 64-bit
  community SteamID.

  ## Examples

      iex> Get5Api.Steam.SteamID.steam_id_to_community_id("STEAM_0:1:546352")
      76561197961358433

      iex> Get5Api.Steam.SteamID.steam_id_to_community_id("[U:1:1092705]")
      76561197961358433
  """
  @spec steam_id_to_community_id(binary) :: pos_integer
  def steam_id_to_community_id(
        <<"STEAM_", _::binary-size(1), ":", steam_id1::binary-size(1), ":", steam_id2::binary>>
      ) do
    {steam_id1, ""} = Integer.parse(steam_id1)
    {steam_id2, ""} = Integer.parse(steam_id2)
    steam_id1 + steam_id2 * 2 + 76_561_197_960_265_728
  end

  def steam_id_to_community_id(<<"[U:", steam_id1::binary-size(1), ":", steam_id2::binary>>) do
    {steam_id1, ""} = Integer.parse(steam_id1)
    {steam_id2, "]"} = Integer.parse(steam_id2)
    steam_id1 + steam_id2 + 76_561_197_960_265_727
  end

  def steam_id_to_community_id(steam_id) do
    raise "Cannot convert SteamID \"#{steam_id}\" to a community ID."
  end

  @doc """
  Returns the base URL for the given 64-bit community SteamID or custom URL.

  ## Examples

      iex> Get5Api.Steam.SteamID.base_url(76561197961358433)
      "http://steamcommunity.com/profiles/76561197961358433"

      iex> Get5Api.Steam.SteamID.base_url("ericentin")
      "http://steamcommunity.com/id/ericentin"
  """
  @spec base_url(pos_integer | binary) :: binary
  def base_url(community_id_or_custom_url) when is_integer(community_id_or_custom_url) do
    "https://steamcommunity.com/profiles/#{community_id_or_custom_url}"
  end

  def base_url(community_id_or_custom_url) when is_binary(community_id_or_custom_url) do
    if is_steam64?(community_id_or_custom_url) do
      "https://steamcommunity.com/profiles/#{community_id_or_custom_url}"
    else
      base_url(community_id_or_custom_url)
    end
  end

  def base_url(community_id_or_custom_url) when is_binary(community_id_or_custom_url) do
    "https://steamcommunity.com/id/#{community_id_or_custom_url}"
  end
end
