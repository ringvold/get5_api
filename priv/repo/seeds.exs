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
alias Get5Api.Repo

%Team{name: "Genesis", players: %{"12340987" => "L0Lpalme", "9832470" => "Madde"}} |> Repo.insert!
%Team{name: "Astralis",players: %{"98234789234" => "Dupreeh", "83622425197" => "Dev1ce"}} |> Repo.insert!
