module Shared exposing
    ( Flags
    , Model
    , Msg
    , init
    , subscriptions
    , update
    )

import Json.Decode as Json
import RemoteData exposing (RemoteData(..))
import Request exposing (Request)
import Result


type alias Flags =
    Json.Value


type alias Model =
    { baseUrl : String }


type Msg
    = NoOp


init : Request -> Flags -> ( Model, Cmd Msg )
init _ flags =
    let
        baseUrl =
            flags
                |> decodeFlagWithDefault
                    "baseUrl"
                    Json.string
                    "baseUrlDecodeError"

        debug =
            case Json.decodeValue (Json.field "baseUrl" Json.string) flags of
                Err err ->
                    Debug.log "flags" <| Json.errorToString err

                Ok a ->
                    Debug.log "success" a
    in
    ( { baseUrl = baseUrl }, Cmd.none )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


decodeFlagWithDefault : String -> Json.Decoder a -> a -> Json.Value -> a
decodeFlagWithDefault name decoder default flags =
    Json.decodeValue (Json.field name decoder) flags
        |> Result.withDefault default
