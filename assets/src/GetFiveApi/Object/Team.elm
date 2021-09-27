-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GetFiveApi.Object.Team exposing (..)

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
import Json.Decode as Decode


id : SelectionSet GetFiveApi.ScalarCodecs.Id GetFiveApi.Object.Team
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GetFiveApi.ScalarCodecs.codecs |> GetFiveApi.Scalar.unwrapCodecs |> .codecId |> .decoder)


name : SelectionSet String GetFiveApi.Object.Team
name =
    Object.selectionForField "String" "name" [] Decode.string


players :
    SelectionSet decodesTo GetFiveApi.Object.Player
    -> SelectionSet (Maybe (List (Maybe decodesTo))) GetFiveApi.Object.Team
players object____ =
    Object.selectionForCompositeField "players" [] object____ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)
