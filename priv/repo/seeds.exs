# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Get5Api.Repo.insert!(%Get5Api.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Get5Api.Accounts.User
alias Get5Api.Teams.Team
alias Get5Api.Teams.Player
alias Get5Api.Matches.Match
alias Get5Api.GameServers
alias Get5Api.GameServers.GameServer
alias Get5Api.Stats.MapStats
alias Get5Api.Stats.PlayerStats
alias Get5Api.Repo

user =
  %User{
    email: "test@example.com",
    password: "qwer1234",
    hashed_password: Bcrypt.hash_pwd_salt("qwer1234")
  }
  |> Repo.insert!()

user2 =
  %User{
    email: "test2@example.com",
    password: "qwer1234",
    hashed_password: Bcrypt.hash_pwd_salt("qwer1234")
  }
  |> Repo.insert!()

genesis =
  %Team{
    name: "Genesis",
    user_id: user.id,
    players: [
      %Player{steam_id: "12340987", name: "L0Lpalme"},
      %Player{steam_id: "9832470", name: "Madde"},
      %Player{steam_id: "76561198279375306", name: "s1mple"}
    ]
  }
  |> Repo.insert!()

astralis =
  %Team{
    name: "Astralis",
    user_id: user.id,
    public: true,
    players: [
      %Player{steam_id: "83622425197", name: "Dev1ce"},
      %Player{steam_id: "76561198010511021", name: "gla1ve"},
      %Player{steam_id: "76561197979669175", name: "k0nfig"},
      %Player{steam_id: "76561198028458803", name: "blameF"},
      %Player{steam_id: "76561197990682262", name: "Xyp9x"}
    ]
  }
  |> Repo.insert!()

_faze =
  %Team{
    name: "Faze",
    user_id: user.id,
    public: true,
    players: [
      %Player{steam_id: "76561197961275685", name: "Broky"},
      %Player{steam_id: "76561197989430253", name: "karrigan"},
      %Player{steam_id: "76561197997351207", name: "rain"},
      %Player{steam_id: "76561197991272318", name: "ropz"},
      %Player{steam_id: "76561198016255205", name: "Twistzz"}
    ]
  }
  |> Repo.insert!()

{:ok, server} =
  GameServers.create_game_server(%{
    user_id: user2.id,
    name: "MyServer",
    host: "192.168.1.2",
    port: 27015,
    rcon_password: "1234"
  })

match =
  %Match{
    user_id: user.id,
    team1_id: genesis.id,
    team2_id: astralis.id,
    api_key: "ølaksdf",
    status: :pending,
    enforce_teams: true,
    max_maps: 1,
    title: "Genesis vs Astralis",
    series_type: :bo1,
    spectator_ids: ["92034275", "02340435934"],
    game_server_id: server.id,
    map_list: ["de_dust2"]
  }
  |> Repo.insert!()

map_stats =
  %MapStats{
    team1_score: 14,
    team2_score: 10,
    map_number: 0,
    map_name: "de_dust2",
    match_id: match.id,
    winner_id: genesis.id
  }
  |> Repo.insert!()

%PlayerStats{
  match_id: match.id,
  map_stats_id: map_stats.id,
  team_id: genesis.id,
  steam_id: "76561198279375306",
  name: "s1mple",
  kills: 34,
  deaths: 8,
  assists: 5,
  flash_assists: 3,
  team_kills: 0,
  suicides: 0,
  damage: 2948,
  utility_damage: 173,
  enemies_flashed: 6,
  friendlies_flashed: 2,
  knife_kills: 1,
  headshot_kills: 19,
  rounds_played: 27,
  bomb_defuses: 4,
  bomb_plants: 3,
  "1k": 3,
  "2k": 2,
  "3k": 3,
  "4k": 0,
  "5k": 1,
  "1v1": 1,
  "1v2": 3,
  "1v3": 2,
  "1v4": 0,
  "1v5": 1,
  first_kills_t: 6,
  first_kills_ct: 5,
  first_deaths_t: 1,
  first_deaths_ct: 1,
  trade_kills: 3,
  kast: 23,
  score: 45,
  mvp: 4
}
|> Repo.insert!()

%PlayerStats{
  match_id: match.id,
  map_stats_id: map_stats.id,
  team_id: astralis.id,
  steam_id: "76561197990682262",
  name: "Xyp9x",
  kills: 20,
  deaths: 15,
  assists: 2,
  flash_assists: 3,
  team_kills: 0,
  suicides: 0,
  damage: 1000,
  utility_damage: 93,
  enemies_flashed: 6,
  friendlies_flashed: 4,
  knife_kills: 0,
  headshot_kills: 3,
  rounds_played: 27,
  bomb_defuses: 4,
  bomb_plants: 3,
  "1k": 3,
  "2k": 2,
  "3k": 3,
  "4k": 0,
  "5k": 1,
  "1v1": 1,
  "1v2": 3,
  "1v3": 2,
  "1v4": 0,
  "1v5": 1,
  first_kills_t: 6,
  first_kills_ct: 5,
  first_deaths_t: 1,
  first_deaths_ct: 1,
  trade_kills: 3,
  kast: 23,
  score: 45,
  mvp: 4
}
|> Repo.insert!()
