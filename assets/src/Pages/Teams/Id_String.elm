module Pages.Teams.Id_String exposing (Model, Msg, Params, page)

import Api exposing (GraphqlData)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import RemoteData exposing (RemoteData(..))
import Shared
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)
import Team exposing (Player, Team)


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
    { team : GraphqlData Team }


init : Shared.Model -> Url Params -> ( Model, Cmd Msg )
init shared { params } =
    ( { team = Loading }, Cmd.batch [ Cmd.map TeamReceived (Api.getTeam params.id) ] )



-- UPDATE


type Msg
    = TeamReceived (GraphqlData Team)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamReceived team ->
            ( { model | team = team }, Cmd.none )


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
    { title = "Team"
    , body = [ viewings model.team ]
    }


viewings : GraphqlData Team -> Element Msg
viewings result =
    case result of
        NotAsked ->
            text "Not asked for servers yet"

        Loading ->
            text "Loading servers"

        Failure err ->
            text "Error!"

        Success team ->
            column []
                [ el [ Region.heading 1, Font.size 30 ] <| text team.name
                , viewPlayers team.players
                ]


viewPlayers : List Player -> Element Msg
viewPlayers players =
    players
        |> List.map
            (\player ->
                case player.name of
                    Just name ->
                        name ++ ": " ++ player.id |> text

                    Nothing ->
                        "Steam ID: " ++ player.id |> text
            )
        |> List.append [ el [ Region.heading 2 ] <| text "Players:" ]
        |> column []
