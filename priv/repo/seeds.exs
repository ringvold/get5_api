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

alias Get5Api.Teams.Team
alias Get5Api.Matches.Match
alias Get5Api.GameServers.GameServer
alias Get5Api.Repo

genesis = %Team{name: "Genesis", players: %{"12340987" => "L0Lpalme", "9832470" => "Madde"}} |> Repo.insert!
astralis = %Team{name: "Astralis",players: %{"98234789234" => "Dupreeh", "83622425197" => "Dev1ce"}} |> Repo.insert!

server = %GameServer{name: "MyServer", host: "192.168.1.2", port: "27015", rcon_password: "1234"} |> Repo.insert!

match = %Match{team1_id: genesis.id, team2_id: astralis.id, api_key: "ølaksdf", status: "pending", enforce_teams: true, max_maps: 1, title: "Genesis vs Astralis", series_type: :bo1, spectator_ids: ["92034275", "02340435934"], game_server_id: server.id} |> Repo.insert!
