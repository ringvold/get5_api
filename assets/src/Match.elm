module Match exposing (CreateMatch, Match, MatchLight, Matches, SideType(..), createToOptionalArgs, createToRequiredArgs, seriesTypeFromGraphql, seriesTypeToString, sideTypeFromGraphql)

import GetFiveApi.Enum.SeriesType as GSeriesType
import GetFiveApi.Enum.SideType as GSideType
import GetFiveApi.Mutation as Mutation
import GetFiveApi.Scalar exposing (Id(..))
import Server exposing (Server)
import ServerId exposing (ServerId)
import Team exposing (Team)
import TeamId exposing (TeamId)


type alias Matches =
    List Match


type alias Match =
    { id : String
    , team1 : Team
    , team2 : Team
    , seriesType : SeriesType
    , server : Server
    }


type SideType
    = AlwaysKnife
    | NeverKnife
    | Standard


type SeriesType
    = Bo1
    | Bo1Preset
    | Bo2
    | Bo3
    | Bo5
    | Bo7


type alias MatchLight =
    { id : String
    , team1Name : String
    , team2Name : String
    }


type alias CreateMatch =
    { team1 : TeamId
    , team2 : TeamId
    , serverId : ServerId
    , maps : List String
    }


createToRequiredArgs : CreateMatch -> Mutation.CreateMatchRequiredArguments
createToRequiredArgs match =
    { gameServerId = ServerId.idToScalar match.serverId
    , team1Id = TeamId.idToScalar match.team1
    , team2Id = TeamId.idToScalar match.team2
    , vetoMapPool = match.maps
    }



---- OptionalArgiments
--{ enforceTeams = OptionalArgument Bool
--, seriesType = OptionalArgument GetFiveApi.Enum.SeriesType.SeriesType
--, sideType = OptionalArgument GetFiveApi.Enum.SideType.SideType
--, spectatorIds = OptionalArgument (List (Maybe String))
--, vetoFirst = OptionalArgument GetFiveApi.Enum.MatchTeam.MatchTeam
--}


createToOptionalArgs : CreateMatch -> Mutation.CreateMatchOptionalArguments -> Mutation.CreateMatchOptionalArguments
createToOptionalArgs match options =
    options


seriesTypeFromGraphql : GSeriesType.SeriesType -> SeriesType
seriesTypeFromGraphql seriesType =
    case seriesType of
        GSeriesType.Bo1Preset ->
            Bo1Preset

        GSeriesType.Bo1 ->
            Bo1

        GSeriesType.Bo2 ->
            Bo2

        GSeriesType.Bo3 ->
            Bo3

        GSeriesType.Bo5 ->
            Bo5

        GSeriesType.Bo7 ->
            Bo7


sideTypeFromGraphql : GSideType.SideType -> SideType
sideTypeFromGraphql seriesType =
    case seriesType of
        GSideType.Standard ->
            Standard

        GSideType.AlwaysKnife ->
            AlwaysKnife

        GSideType.NeverKnife ->
            NeverKnife


seriesTypeToString : SeriesType -> String
seriesTypeToString seriesType =
    case seriesType of
        Bo1Preset ->
            "Bo1Preset"

        Bo1 ->
            "Bo1"

        Bo2 ->
            "Bo2"

        Bo3 ->
            "Bo3"

        Bo5 ->
            "Bo5"

        Bo7 ->
            "Bo7"


sideTypeToString : SideType -> String
sideTypeToString sideType =
    case sideType of
        Standard ->
            "Standard"

        AlwaysKnife ->
            "AlwaysKnife"

        NeverKnife ->
            "NeverKnife"
