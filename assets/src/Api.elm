module Api exposing (GraphqlData, getAllServers, getAllTeams, getServer, getTeam)

import GetFiveApi.Object as GObject
import GetFiveApi.Object.GameServer as GServer
import GetFiveApi.Object.Player as GPlayer
import GetFiveApi.Object.Team as GTeam
import GetFiveApi.Query as Query
import GetFiveApi.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Server exposing (Server, Servers)
import Team exposing (Player, Team, Teams)


type alias GraphqlData a =
    RemoteData (Graphql.Http.Error a) a


url : String
url =
    "http://localhost:4000/api/graphql/v1"



-- Request


sendRequest : SelectionSet a RootQuery -> Cmd (RemoteData (Graphql.Http.Error a) a)
sendRequest query =
    query
        |> Graphql.Http.queryRequest url
        |> Graphql.Http.send RemoteData.fromResult


getAllTeams : Cmd (GraphqlData Teams)
getAllTeams =
    sendRequest allTeams


getTeam : String -> Cmd (GraphqlData Team)
getTeam id =
    teamQuery id
        |> sendRequest


getAllServers : Cmd (GraphqlData Servers)
getAllServers =
    allServers
        |> sendRequest


getServer : String -> Cmd (GraphqlData Server)
getServer id =
    serverQuery id
        |> sendRequest



-- Queries


teamQuery : String -> SelectionSet Team RootQuery
teamQuery id =
    Query.team { id = Id id } <|
        SelectionSet.map3 Team
            (SelectionSet.map scalarIdToString GTeam.id)
            GTeam.name
            (SelectionSet.map (List.filterMap identity) playersSelectionSet)


serverQuery : String -> SelectionSet Server RootQuery
serverQuery id =
    Query.gameServer { id = Id id } <|
        (SelectionSet.succeed Server
            |> with (SelectionSet.map scalarIdToString GServer.id)
            |> with GServer.name
            |> with GServer.host
            |> with GServer.port_
            |> with GServer.inUse
        )


playersSelectionSet : SelectionSet (List (Maybe Player)) GObject.Team
playersSelectionSet =
    GTeam.players
        (SelectionSet.map2 Player
            GPlayer.id
            GPlayer.name
        )


allTeams : SelectionSet Teams RootQuery
allTeams =
    Query.allTeams <|
        SelectionSet.map3 Team
            (SelectionSet.map scalarIdToString GTeam.id)
            GTeam.name
            (SelectionSet.succeed [])


allServers : SelectionSet Servers RootQuery
allServers =
    Query.allGameServers <|
        SelectionSet.map5 Server
            (SelectionSet.map scalarIdToString GServer.id)
            GServer.name
            GServer.host
            GServer.port_
            GServer.inUse



-- stopPlaceSelection : SelectionSet StopPlace EO.StopPlace
-- stopPlaceSelection =
--     SelectionSet.map3 StopPlace
--         (SelectionSet.map scalarIdToString EOS.id)
--         EOS.name
--         (SelectionSet.map (List.filterMap identity) estimatedCalls)


scalarIdToString : GetFiveApi.Scalar.Id -> String
scalarIdToString scalarId =
    case scalarId of
        Id id ->
            id
