module TeamId exposing (TeamId, idToScalar, scalarToId, toString, urlParser)

import GetFiveApi.Scalar exposing (Id(..))
import Json.Decode exposing (Decoder)
import Url.Parser exposing (Parser)


type TeamId
    = TeamId String


toString : TeamId -> String
toString (TeamId id) =
    id


urlParser : Parser (TeamId -> a) a
urlParser =
    Url.Parser.map TeamId Url.Parser.string


decode : Decoder TeamId
decode =
    Json.Decode.string
        |> Json.Decode.map TeamId


scalarToId : GetFiveApi.Scalar.Id -> TeamId
scalarToId (Id id) =
    TeamId id


idToScalar : TeamId -> GetFiveApi.Scalar.Id
idToScalar (TeamId id) =
    Id id
