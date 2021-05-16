module Pages.Servers.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Gen.Params.Servers.Id_ exposing (Params)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Server exposing (Server, Servers)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init req.params
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { server : GraphqlData Server }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { server = Loading }
    , Cmd.batch
        [ Cmd.map ServerReceived (Api.getServer params.id)
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
    , element = Element.column [] [ View.graphDataView serverView model.server ]
    }


serverView : Server -> Element Msg
serverView server =
    column []
        [ text server.name |> el [ Region.heading 1, Font.size 25 ]
        , "Host: " ++ server.host |> text |> el []
        , "Port: " ++ server.port_ |> text |> el []
        , "In use: " ++ boolToString server.inUse |> text |> el []
        ]


boolToString : Bool -> String
boolToString bool =
    if bool then
        "Yes"

    else
        "No"
