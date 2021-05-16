module Pages.Teams.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Gen.Params.Teams.Id_ exposing (Params)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Team exposing (Player, Team)
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
    { team : GraphqlData Team }


init : Params -> ( Model, Cmd Msg )
init params =
    ( { team = Loading }
    , Cmd.batch
        [ Cmd.map TeamReceived (Api.getTeam params.id)
        ]
    )



-- UPDATE


type Msg
    = TeamReceived (GraphqlData Team)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamReceived team ->
            ( { model | team = team }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title =
        RemoteData.map (.name >> String.append "Team ") model.team
            |> RemoteData.withDefault "Unknown team"
    , element = Element.column [] [ View.graphDataView viewTeam model.team ]
    }


viewTeam : Team -> Element Msg
viewTeam team =
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
