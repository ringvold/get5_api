module Pages.Servers.Id_String exposing (Model, Msg, Params, page)

import Api exposing (GraphqlData)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import RemoteData exposing (RemoteData(..))
import Server exposing (Server, Servers)
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


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
    { id : String }


type alias Model =
    { server : GraphqlData Server }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
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
    { title =
        RemoteData.map .name model.server
            |> RemoteData.withDefault "Unknown server"
    , body = [ Shared.graphDataView serverView model.server ]
    }


serverView : Server -> Element Msg
serverView server =
    column []
        [ text server.name |> el [ Region.heading 1, Font.size 25 ]
        , "Host: " ++ server.host |> text |> el []
        , "Port: " ++ server.port_ |> text |> el []
        , "In use: " ++ boolToString server.inUse |> text |> el []
        ]


boolToString bool =
    case bool of
        True ->
            "Yes"

        False ->
            "No"
