-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GetFiveApi.Mutation exposing (..)

import GetFiveApi.InputObject
import GetFiveApi.Interface
import GetFiveApi.Object
import GetFiveApi.Scalar
import GetFiveApi.ScalarCodecs
import GetFiveApi.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode exposing (Decoder)


type alias AddPlayerOptionalArguments =
    { name : OptionalArgument String }


type alias AddPlayerRequiredArguments =
    { steamId : String
    , teamId : String
    }


{-| Add player to a team
-}
addPlayer :
    (AddPlayerOptionalArguments -> AddPlayerOptionalArguments)
    -> AddPlayerRequiredArguments
    -> SelectionSet decodesTo GetFiveApi.Object.Player
    -> SelectionSet (List decodesTo) RootMutation
addPlayer fillInOptionals____ requiredArgs____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { name = Absent }

        optionalArgs____ =
            [ Argument.optional "name" filledInOptionals____.name Encode.string ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "addPlayer" (optionalArgs____ ++ [ Argument.required "steamId" requiredArgs____.steamId Encode.string, Argument.required "teamId" requiredArgs____.teamId Encode.string ]) object____ (identity >> Decode.list)


type alias CreateGameServerRequiredArguments =
    { host : String
    , name : String
    , port_ : String
    , rconPassword : String
    }


{-| Create a game server
-}
createGameServer :
    CreateGameServerRequiredArguments
    -> SelectionSet decodesTo GetFiveApi.Object.GameServer
    -> SelectionSet (Maybe decodesTo) RootMutation
createGameServer requiredArgs____ object____ =
    Object.selectionForCompositeField "createGameServer" [ Argument.required "host" requiredArgs____.host Encode.string, Argument.required "name" requiredArgs____.name Encode.string, Argument.required "port" requiredArgs____.port_ Encode.string, Argument.required "rconPassword" requiredArgs____.rconPassword Encode.string ] object____ (identity >> Decode.nullable)


type alias CreateMatchOptionalArguments =
    { enforceTeams : OptionalArgument Bool
    , spectatorIds : OptionalArgument (List (Maybe String))
    , title : OptionalArgument String
    , vetoFirst : OptionalArgument String
    }


type alias CreateMatchRequiredArguments =
    { gameServer : String
    , seriesType : String
    , team1 : String
    , team2 : String
    , vetoMapPool : List (Maybe String)
    }


{-| Create a match
-}
createMatch :
    (CreateMatchOptionalArguments -> CreateMatchOptionalArguments)
    -> CreateMatchRequiredArguments
    -> SelectionSet decodesTo GetFiveApi.Object.Match
    -> SelectionSet (Maybe decodesTo) RootMutation
createMatch fillInOptionals____ requiredArgs____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { enforceTeams = Absent, spectatorIds = Absent, title = Absent, vetoFirst = Absent }

        optionalArgs____ =
            [ Argument.optional "enforceTeams" filledInOptionals____.enforceTeams Encode.bool, Argument.optional "spectatorIds" filledInOptionals____.spectatorIds (Encode.string |> Encode.maybe |> Encode.list), Argument.optional "title" filledInOptionals____.title Encode.string, Argument.optional "vetoFirst" filledInOptionals____.vetoFirst Encode.string ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "createMatch" (optionalArgs____ ++ [ Argument.required "gameServer" requiredArgs____.gameServer Encode.string, Argument.required "seriesType" requiredArgs____.seriesType Encode.string, Argument.required "team1" requiredArgs____.team1 Encode.string, Argument.required "team2" requiredArgs____.team2 Encode.string, Argument.required "vetoMapPool" requiredArgs____.vetoMapPool (Encode.string |> Encode.maybe |> Encode.list) ]) object____ (identity >> Decode.nullable)


type alias CreateTeamOptionalArguments =
    { players : OptionalArgument (List (Maybe GetFiveApi.InputObject.PlayerInput)) }


type alias CreateTeamRequiredArguments =
    { name : String }


{-| Create a team
-}
createTeam :
    (CreateTeamOptionalArguments -> CreateTeamOptionalArguments)
    -> CreateTeamRequiredArguments
    -> SelectionSet decodesTo GetFiveApi.Object.Team
    -> SelectionSet (Maybe decodesTo) RootMutation
createTeam fillInOptionals____ requiredArgs____ object____ =
    let
        filledInOptionals____ =
            fillInOptionals____ { players = Absent }

        optionalArgs____ =
            [ Argument.optional "players" filledInOptionals____.players (GetFiveApi.InputObject.encodePlayerInput |> Encode.maybe |> Encode.list) ]
                |> List.filterMap identity
    in
    Object.selectionForCompositeField "createTeam" (optionalArgs____ ++ [ Argument.required "name" requiredArgs____.name Encode.string ]) object____ (identity >> Decode.nullable)


type alias RemovePlayerRequiredArguments =
    { steamId : String
    , teamId : String
    }


{-| Remove player from a team
-}
removePlayer :
    RemovePlayerRequiredArguments
    -> SelectionSet decodesTo GetFiveApi.Object.Player
    -> SelectionSet (List decodesTo) RootMutation
removePlayer requiredArgs____ object____ =
    Object.selectionForCompositeField "removePlayer" [ Argument.required "steamId" requiredArgs____.steamId Encode.string, Argument.required "teamId" requiredArgs____.teamId Encode.string ] object____ (identity >> Decode.list)
