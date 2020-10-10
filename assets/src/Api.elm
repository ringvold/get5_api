module Api exposing (GraphqlData, Team, Teams, getAllTeams)

import GetFiveApi.Object.Team as GTeam
import GetFiveApi.Query as Query
import GetFiveApi.Scalar exposing (Id(..))
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet, with)
import RemoteData exposing (RemoteData)


type alias Teams =
    List Team


type alias Team =
    { id : String
    , name : String
    }


type alias GraphqlData a =
    RemoteData (Graphql.Http.Error a) a


getAllTeams : Cmd (RemoteData (Graphql.Http.Error Teams) Teams)
getAllTeams =
    allTeams
        |> Graphql.Http.queryRequest "http://localhost:4000/api/graphql/v1"
        |> Graphql.Http.send RemoteData.fromResult


allTeams : SelectionSet Teams RootQuery
allTeams =
    Query.allTeams <|
        SelectionSet.map2 Team
            (SelectionSet.map scalarIdToString GTeam.id)
            GTeam.name



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
