module Pages.Servers exposing (Model, Msg, page)

import Api
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Gen.Params.Servers exposing (Params)
import Gen.Route as Route
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Server exposing (Server, Servers)
import Shared
import Styling
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { servers : Api.GraphqlData Servers }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { servers = Loading }
    , Cmd.batch
        [ Cmd.map ServersReceived <| Api.getAllServers shared.baseUrl ]
    )



-- UPDATE


type Msg
    = ServersReceived (Api.GraphqlData Servers)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ServersReceived servers ->
            ( { model | servers = servers }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Servers"
    , element =
        Element.column []
            [ el [ Region.heading 1, Font.size 25 ] (text "Servers")
            , View.graphDataView viewServers model.servers
            ]
    }


viewServers : Servers -> Element msg
viewServers servers =
    List.map serverView servers
        |> column []


serverView : Server -> Element msg
serverView server =
    link Styling.link
        { url = Route.toHref (Route.Servers__Id_ { id = server.id })
        , label = text server.name
        }
