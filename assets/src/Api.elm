module Api exposing (GraphqlData, addPlayer, createTeam, getAllServers, getAllTeams, getServer, getTeam, removePlayer)

import GetFiveApi.Mutation as Mutation
import GetFiveApi.Object as GObject
import GetFiveApi.Object.GameServer as GServer
import GetFiveApi.Object.Player as GPlayer
import GetFiveApi.Object.Team as GTeam
import GetFiveApi.Query as Query
import GetFiveApi.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)
import Server exposing (Server, Servers)
import Team exposing (Player, Team, Teams)


type alias GraphqlData a =
    RemoteData (Graphql.Http.Error ()) a


url : String -> String
url baseUrl =
    baseUrl ++ "/api/graphql/v1"



-- Request
-- Use of `discardParsedErrorData` is a hack for now.
-- Probably need to handle error properly at a point.


getAllTeams : String -> Cmd (GraphqlData Teams)
getAllTeams baseUrl =
    sendRequest baseUrl allTeams


getTeam : String -> String -> Cmd (GraphqlData Team)
getTeam baseUrl id =
    teamQuery id
        |> sendRequest baseUrl


addPlayer baseUrl teamId player =
    addPlayerMutation teamId player
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


removePlayer baseUrl teamId player =
    removePlayerMutation teamId player
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


createTeam : String -> { a | name : String } -> Cmd (RemoteData (Graphql.Http.Error (Maybe Team)) (Maybe Team))
createTeam baseUrl team =
    createTeamMutation team
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


getAllServers : String -> Cmd (GraphqlData Servers)
getAllServers baseUrl =
    allServers
        |> sendRequest baseUrl


getServer : String -> String -> Cmd (GraphqlData Server)
getServer baseUrl id =
    serverQuery id
        |> sendRequest baseUrl


sendRequest : String -> SelectionSet a RootQuery -> Cmd (GraphqlData a)
sendRequest baseUrl query =
    query
        |> Graphql.Http.queryRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)



-- Queries


teamQuery : String -> SelectionSet Team RootQuery
teamQuery id =
    Query.team { id = Id id } <|
        teamSelectionSet


teamSelectionSet : SelectionSet Team GObject.Team
teamSelectionSet =
    SelectionSet.map3 Team
        (SelectionSet.map scalarIdToString GTeam.id)
        GTeam.name
        (SelectionSet.withDefault [] playersSelectionSet
            |> SelectionSet.map (List.filterMap identity)
        )


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


playersSelectionSet : SelectionSet (Maybe (List (Maybe Player))) GObject.Team
playersSelectionSet =
    GTeam.players
        (SelectionSet.map2 Player
            GPlayer.steamId
            GPlayer.name
        )


playerSelectionSet : SelectionSet Player GObject.Player
playerSelectionSet =
    SelectionSet.map2 Player
        GPlayer.steamId
        GPlayer.name


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



-- Mutations


createTeamMutation : { a | name : String } -> SelectionSet (Maybe Team) RootMutation
createTeamMutation team =
    Mutation.createTeam
        identity
        { name = team.name }
        teamSelectionSet


addPlayerMutation : String -> Player -> SelectionSet (List Player) RootMutation
addPlayerMutation teamId player =
    Mutation.addPlayer
        identity
        { steamId = player.id
        , teamId = teamId
        }
        playerSelectionSet


removePlayerMutation : String -> Player -> SelectionSet (List Player) RootMutation
removePlayerMutation teamId player =
    Mutation.removePlayer
        { steamId = player.id
        , teamId = teamId
        }
        playerSelectionSet



-- Helpers


scalarIdToString : GetFiveApi.Scalar.Id -> String
scalarIdToString (Id id) =
    id
