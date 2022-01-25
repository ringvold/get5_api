-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module GetFiveApi.Object.ValidationMessage exposing (..)

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


{-| A unique error code for the type of validation used.
-}
code : SelectionSet String GetFiveApi.Object.ValidationMessage
code =
    Object.selectionForField "String" "code" [] Decode.string


{-| The input field that the error applies to. The field can be used to
identify which field the error message should be displayed next to in the
presentation layer.

If there are multiple errors to display for a field, multiple validation
messages will be in the result.

This field may be null in cases where an error cannot be applied to a specific field.

-}
field : SelectionSet (Maybe String) GetFiveApi.Object.ValidationMessage
field =
    Object.selectionForField "(Maybe String)" "field" [] (Decode.string |> Decode.nullable)


{-| A friendly error message, appropriate for display to the end user.

The message is interpolated to include the appropriate variables.

Example: `Username must be at least 10 characters`

This message may change without notice, so we do not recommend you match against the text.
Instead, use the _code_ field for matching.

-}
message : SelectionSet (Maybe String) GetFiveApi.Object.ValidationMessage
message =
    Object.selectionForField "(Maybe String)" "message" [] (Decode.string |> Decode.nullable)


{-| A list of substitutions to be applied to a validation message template
-}
options :
    SelectionSet decodesTo GetFiveApi.Object.ValidationOption
    -> SelectionSet (Maybe (List (Maybe decodesTo))) GetFiveApi.Object.ValidationMessage
options object____ =
    Object.selectionForCompositeField "options" [] object____ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)


{-| A template used to generate the error message, with placeholders for option substiution.

Example: `Username must be at least {count} characters`

This message may change without notice, so we do not recommend you match against the text.
Instead, use the _code_ field for matching.

-}
template : SelectionSet (Maybe String) GetFiveApi.Object.ValidationMessage
template =
    Object.selectionForField "(Maybe String)" "template" [] (Decode.string |> Decode.nullable)