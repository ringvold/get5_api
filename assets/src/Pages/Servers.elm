module Pages.Servers exposing (Model, Msg, page)

import Api
import Gen.Params.Servers exposing (Params)
import Gen.Route as Route
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
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
    , body =
        [ Html.h1 [] [ Html.text "Servers" ]
        , View.graphDataView viewServers model.servers
        ]
    }


viewServers : Servers -> Html msg
viewServers servers =
    List.map serverView servers
        |> div []


serverView : Server -> Html msg
serverView server =
    a [ Attr.href <| Route.toHref (Route.Servers__Id_ { id = server.id }) ]
        [ text server.name ]
