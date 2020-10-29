module Pages.Servers exposing (Model, Msg, Params, page)

import Api
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import RemoteData exposing (RemoteData(..))
import Server exposing (Server, Servers)
import Shared
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Styling


page : Page Params Model Msg
page =
    Page.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , save = save
        , load = load
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { servers : Api.GraphqlData Servers }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { servers = Loading }
    , Cmd.batch
        [ Cmd.map ServersReceived Api.getAllServers ]
    )



-- UPDATE


type Msg
    = ServersReceived (Api.GraphqlData Servers)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ServersReceived servers ->
            ( { model | servers = servers }, Cmd.none )


save : Model -> Shared.Model -> Shared.Model
save model shared =
    shared


load : Shared.Model -> Model -> ( Model, Cmd Msg )
load shared model =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Servers"
    , body =
        [ el [ Region.heading 1, Font.size 25 ] (text "Servers")
        , Shared.graphDataView viewServers model.servers
        ]
    }


viewServers : Servers -> Element msg
viewServers servers =
    List.map serverView servers
        |> column []


serverView : Server -> Element msg
serverView server =
    link Styling.link
        { url = Route.toString (Route.Servers__Id_String { id = server.id })
        , label = text server.name
        }
