-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GetFiveApi.Object.GameServer exposing (..)

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


host : SelectionSet String GetFiveApi.Object.GameServer
host =
    Object.selectionForField "String" "host" [] Decode.string


id : SelectionSet GetFiveApi.ScalarCodecs.Id GetFiveApi.Object.GameServer
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (GetFiveApi.ScalarCodecs.codecs |> GetFiveApi.Scalar.unwrapCodecs |> .codecId |> .decoder)


inUse : SelectionSet Bool GetFiveApi.Object.GameServer
inUse =
    Object.selectionForField "Bool" "inUse" [] Decode.bool


name : SelectionSet String GetFiveApi.Object.GameServer
name =
    Object.selectionForField "String" "name" [] Decode.string


port_ : SelectionSet String GetFiveApi.Object.GameServer
port_ =
    Object.selectionForField "String" "port" [] Decode.string
