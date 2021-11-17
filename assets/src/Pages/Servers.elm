module Pages.Servers exposing (Model, Msg, page)

import Api
import Gen.Params.Servers exposing (Params)
import Gen.Route as Route
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Html.Styled.Events as Events
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Server exposing (Server, Servers)
import ServerId exposing (ServerId)
import Shared
import Styling
import Tailwind.Utilities as Tw
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared
        , update = update shared
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
    | DeleteServerClicked ServerId
    | DeleteServerReceived (Api.GraphqlData (Maybe Server))


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        ServersReceived servers ->
            ( { model | servers = servers }, Cmd.none )

        DeleteServerClicked id ->
            ( model
            , Api.deleteServer shared.baseUrl id
                |> Cmd.map DeleteServerReceived
            )

        DeleteServerReceived result ->
            ( model, Cmd.map ServersReceived <| Api.getAllServers shared.baseUrl )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Servers"
    , body =
        [ Html.h1 [ Styling.header ]
            [ Html.text "Servers"
            , a
                [ Attr.href <| Route.toHref Route.Servers__New
                , Styling.header_inline_link
                ]
                [ text "New server" ]
            ]
        , View.graphDataView viewServers model.servers
        ]
    }


viewServers : Servers -> Html Msg
viewServers servers =
    List.map serverView servers
        |> div []


serverView : Server -> Html Msg
serverView server =
    div []
        [ a [ Attr.href <| Route.toHref (Route.Servers__Id_ { id = ServerId.toString server.id }) ]
            [ text server.name ]
        , button
            [ Events.onClick <| DeleteServerClicked server.id
            , Attr.css
                [ Tw.pl_1
                , Tw.cursor_pointer
                ]
            ]
            [ text "Delete" ]
        ]
