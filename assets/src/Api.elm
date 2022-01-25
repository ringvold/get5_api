module Api exposing (GraphqlData, GraphqlMutationData, MatchPayload, MutationPayload, ValidationMessage, addPlayer, createMatch, createServer, createTeam, deleteServer, deleteTeam, getAllMatches, getAllServers, getAllServersLight, getAllTeams, getAllTeamsLight, getMatch, getServer, getTeam, removePlayer)

import GetFiveApi.Enum.SeriesType as GSeriesType
import GetFiveApi.Enum.SideType as GSideType
import GetFiveApi.Mutation as Mutation
import GetFiveApi.Object as GObject
import GetFiveApi.Object.GameServer as GServer
import GetFiveApi.Object.Match as GMatch
import GetFiveApi.Object.MatchPayload as GMatchPayload
import GetFiveApi.Object.Player as GPlayer
import GetFiveApi.Object.Team as GTeam
import GetFiveApi.Object.ValidationMessage as GValidationMessage
import GetFiveApi.Query as Query
import GetFiveApi.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import Match exposing (Match, MatchLight, Matches)
import RemoteData exposing (RemoteData)
import Server exposing (Server, ServerLight, Servers)
import ServerId exposing (ServerId)
import Team exposing (Player, Team, TeamLight, Teams)
import TeamId exposing (TeamId)



-- File organized by Team, Server, Match by:
-- 1. Requests
-- 2. Query and selectionsets
-- 3. Mutations
-- 4. Helpers


type alias GraphqlData a =
    RemoteData (Graphql.Http.Error ()) a


type alias GraphqlMutationData a =
    RemoteData (Graphql.Http.Error ()) (Maybe a)


type alias MatchPayload =
    MutationPayload Match


type alias MutationPayload a =
    { messages : Maybe (List (Maybe ValidationMessage))
    , result : Maybe a
    }


type alias ValidationMessage =
    { code : String
    , field : Maybe String
    , message : Maybe String
    }


url : String -> String
url baseUrl =
    baseUrl ++ "/api/graphql/v1"



--
-- Requests
--
-- Use of `discardParsedErrorData` is a hack for now.
-- Probably need to handle error properly at a point.
--
--


sendRequest : String -> SelectionSet a RootQuery -> Cmd (GraphqlData a)
sendRequest baseUrl query =
    query
        |> Graphql.Http.queryRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)



-- Team


getAllTeams : String -> Cmd (GraphqlData Teams)
getAllTeams baseUrl =
    sendRequest baseUrl allTeams


getAllTeamsLight : String -> Cmd (GraphqlData (List TeamLight))
getAllTeamsLight baseUrl =
    sendRequest baseUrl allTeamsLight


getTeam : String -> String -> Cmd (GraphqlData Team)
getTeam baseUrl id =
    teamQuery id
        |> sendRequest baseUrl


addPlayer : String -> TeamId -> Player -> Cmd (RemoteData (Graphql.Http.Error ()) (List Player))
addPlayer baseUrl teamId player =
    addPlayerMutation teamId player
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


removePlayer : String -> TeamId -> String -> Cmd (RemoteData (Graphql.Http.Error ()) (List Player))
removePlayer baseUrl teamId steamId =
    removePlayerMutation teamId steamId
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


createTeam : String -> { a | name : String } -> Cmd (RemoteData (Graphql.Http.Error (Maybe Team)) (Maybe Team))
createTeam baseUrl team =
    createTeamMutation team
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


deleteTeam : String -> TeamId -> Cmd (RemoteData (Graphql.Http.Error ()) (Maybe Team))
deleteTeam baseUrl teamId =
    deleteTeamMutation teamId
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)



-- Server


getAllServers : String -> Cmd (GraphqlData Servers)
getAllServers baseUrl =
    allServers
        |> sendRequest baseUrl


getAllServersLight : String -> Cmd (GraphqlData (List ServerLight))
getAllServersLight baseUrl =
    allServersLight
        |> sendRequest baseUrl


getServer : String -> String -> Cmd (GraphqlData Server)
getServer baseUrl id =
    serverQuery id
        |> sendRequest baseUrl


createServer :
    String
    -> { a | name : String, host : String, port_ : String, password : String }
    -> Cmd (RemoteData (Graphql.Http.Error ()) (Maybe Server))
createServer baseUrl server =
    createGameServerMutation server
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)


deleteServer : String -> ServerId -> Cmd (RemoteData (Graphql.Http.Error ()) (Maybe Server))
deleteServer baseUrl id =
    deleteServerMutation id
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)



-- Match


getAllMatches : String -> Cmd (GraphqlData (List MatchLight))
getAllMatches baseUrl =
    allMatches
        |> sendRequest baseUrl


getMatch : String -> String -> Cmd (GraphqlData Match)
getMatch baseUrl id =
    matchQuery id
        |> sendRequest baseUrl


createMatch :
    String
    -> Match.CreateMatch
    -> Cmd (GraphqlMutationData (MutationPayload Match))
createMatch baseUrl match =
    createMatchMutation match
        |> Graphql.Http.mutationRequest (url baseUrl)
        |> Graphql.Http.send (Graphql.Http.discardParsedErrorData >> RemoteData.fromResult)



--
-- Queries and SelectionSets
--
-----------
--
--
-- Team


teamQuery : String -> SelectionSet Team RootQuery
teamQuery id =
    Query.team { id = Id id } <|
        teamSelectionSet


allTeams : SelectionSet Teams RootQuery
allTeams =
    Query.allTeams <|
        SelectionSet.map3 Team
            (SelectionSet.map TeamId.scalarToId GTeam.id)
            GTeam.name
            (SelectionSet.succeed [])


allTeamsLight : SelectionSet (List TeamLight) RootQuery
allTeamsLight =
    Query.allTeams <|
        SelectionSet.map2 TeamLight
            (SelectionSet.map TeamId.scalarToId GTeam.id)
            GTeam.name


teamSelectionSet : SelectionSet Team GObject.Team
teamSelectionSet =
    SelectionSet.map3 Team
        (SelectionSet.map TeamId.scalarToId GTeam.id)
        GTeam.name
        (SelectionSet.withDefault [] playersSelectionSet
            |> SelectionSet.map (List.filterMap identity)
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



-- Server


serverQuery : String -> SelectionSet Server RootQuery
serverQuery id =
    Query.gameServer { id = Id id } <|
        gameServerSelectionSet


allServers : SelectionSet Servers RootQuery
allServers =
    Query.allGameServers <|
        SelectionSet.map5 Server
            (SelectionSet.map ServerId.scalarToId GServer.id)
            GServer.name
            GServer.host
            GServer.port_
            GServer.inUse


allServersLight : SelectionSet (List ServerLight) RootQuery
allServersLight =
    Query.allGameServers <|
        SelectionSet.map2 ServerLight
            (SelectionSet.map ServerId.scalarToId GServer.id)
            GServer.name


gameServerSelectionSet : SelectionSet Server GObject.GameServer
gameServerSelectionSet =
    SelectionSet.succeed Server
        |> with (SelectionSet.map ServerId.scalarToId GServer.id)
        |> with GServer.name
        |> with GServer.host
        |> with GServer.port_
        |> with GServer.inUse



-- Match


matchQuery : String -> SelectionSet Match RootQuery
matchQuery id =
    Query.match { id = Id id } <|
        matchSelectionSet


allMatches : SelectionSet (List MatchLight) RootQuery
allMatches =
    Query.allMatches <|
        (SelectionSet.succeed MatchLight
            |> with (SelectionSet.map scalarIdToString GMatch.id)
            |> with (GMatch.team1 GTeam.name)
            |> with (GMatch.team2 GTeam.name)
        )


matchSelectionSet : SelectionSet Match GObject.Match
matchSelectionSet =
    SelectionSet.succeed Match
        |> with (SelectionSet.map scalarIdToString GMatch.id)
        |> with (GMatch.team1 teamSelectionSet)
        |> with (GMatch.team2 teamSelectionSet)
        |> with (SelectionSet.map Match.seriesTypeFromGraphql GMatch.seriesType)
        |> with (GMatch.gameServer gameServerSelectionSet)


matchPayloadSelectionSet : SelectionSet (MutationPayload Match) GObject.MatchPayload
matchPayloadSelectionSet =
    SelectionSet.succeed MutationPayload
        |> with (GMatchPayload.messages validationMessageSelectionSet)
        |> with (GMatchPayload.result matchSelectionSet)


validationMessageSelectionSet : SelectionSet ValidationMessage GObject.ValidationMessage
validationMessageSelectionSet =
    SelectionSet.succeed ValidationMessage
        |> with GValidationMessage.code
        |> with GValidationMessage.field
        |> with GValidationMessage.message



--
-- Mutations
--
-------------
--
--
-- Team


createTeamMutation : { a | name : String } -> SelectionSet (Maybe Team) RootMutation
createTeamMutation team =
    Mutation.createTeam
        identity
        { name = team.name }
        teamSelectionSet


deleteTeamMutation : TeamId -> SelectionSet (Maybe Team) RootMutation
deleteTeamMutation teamId =
    Mutation.deleteTeam
        { id = TeamId.toString teamId }
        teamSelectionSet


addPlayerMutation : TeamId -> Player -> SelectionSet (List Player) RootMutation
addPlayerMutation teamId player =
    Mutation.addPlayer
        identity
        { steamId = player.id
        , teamId = TeamId.toString teamId
        }
        playerSelectionSet


removePlayerMutation : TeamId -> String -> SelectionSet (List Player) RootMutation
removePlayerMutation teamId steamId =
    Mutation.removePlayer
        { steamId = steamId
        , teamId = TeamId.toString teamId
        }
        playerSelectionSet



-- Server


createGameServerMutation :
    { a | name : String, host : String, port_ : String, password : String }
    -> SelectionSet (Maybe Server) RootMutation
createGameServerMutation server =
    Mutation.createGameServer
        { name = server.name
        , host = server.host
        , port_ = server.port_
        , rconPassword = server.password
        }
        gameServerSelectionSet


deleteServerMutation : ServerId -> SelectionSet (Maybe Server) RootMutation
deleteServerMutation id =
    Mutation.deleteGameServer
        { id = ServerId.toString id }
        gameServerSelectionSet



-- Match


createMatchMutation : Match.CreateMatch -> SelectionSet (Maybe MatchPayload) RootMutation
createMatchMutation match =
    Mutation.createMatch
        (Match.createToOptionalArgs match)
        (Match.createToRequiredArgs match)
        matchPayloadSelectionSet



--
-- Helpers
--


scalarIdToString : GetFiveApi.Scalar.Id -> String
scalarIdToString (Id id) =
    id
