module Pages.Teams.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Teams.Id_ exposing (Params)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Styling
import Team exposing (Player, Team)
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
    { team : GraphqlData Team }


init : Shared.Model -> Params -> ( Model, Cmd Msg )
init shared params =
    ( { team = Loading }
    , Cmd.batch
        [ Cmd.map TeamReceived (Api.getTeam shared.baseUrl params.id)
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
    , body = [ View.graphDataView viewTeam model.team ]
    }


viewTeam : Team -> Html Msg
viewTeam team =
    div []
        [ h1 [ Styling.header ] [ text team.name ]
        , viewPlayers team.players
        ]


viewPlayers : List Player -> Html Msg
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
        |> List.append [ h1 [] [ text "Players:" ] ]
        |> div []
