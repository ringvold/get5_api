module ServerId exposing (ServerId, decode, scalarToId, toString, urlParser)

import GetFiveApi.Scalar exposing (Id(..))
import Json.Decode exposing (Decoder)
import Url.Parser exposing (Parser)


type ServerId
    = ServerId String


toString : ServerId -> String
toString (ServerId id) =
    id


urlParser : Parser (ServerId -> a) a
urlParser =
    Url.Parser.map ServerId Url.Parser.string


decode : Decoder ServerId
decode =
    Json.Decode.string
        |> Json.Decode.map ServerId


scalarToId : GetFiveApi.Scalar.Id -> ServerId
scalarToId (Id id) =
    ServerId id
