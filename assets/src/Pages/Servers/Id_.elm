module Pages.Servers.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Servers.Id_ exposing (Params)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Server exposing (Server, Servers)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req.params
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { server : GraphqlData Server }


init : Shared.Model -> Params -> ( Model, Cmd Msg )
init shared params =
    ( { server = Loading }
    , Cmd.batch
        [ Cmd.map ServerReceived (Api.getServer shared.baseUrl params.id)
        ]
    )



-- UPDATE


type Msg
    = ServerReceived (GraphqlData Server)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ServerReceived server ->
            ( { model | server = server }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title =
        RemoteData.map .name model.server
            |> RemoteData.withDefault "Unknown server"
    , body = [ View.graphDataView serverView model.server ]
    }


serverView : Server -> Html Msg
serverView server =
    div []
        [ h1 [] [ text server.name ]
        , text ("Host: " ++ server.host)
        , text ("Port: " ++ server.port_)
        , text ("In use: " ++ boolToString server.inUse)
        ]


boolToString : Bool -> String
boolToString bool =
    if bool then
        "Yes"

    else
        "No"
