module Pages.Teams exposing (Model, Msg, Params, page)

import Api exposing (GraphqlData, Team, Teams)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import RemoteData exposing (RemoteData(..), WebData)
import Spa.Document exposing (Document)
import Spa.Page as Page exposing (Page)
import Spa.Url as Url exposing (Url)


page : Page Params Model Msg
page =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Params =
    ()


type alias Model =
    { teams : GraphqlData Teams }


init : Url Params -> ( Model, Cmd Msg )
init { params } =
    ( { teams = Loading }
    , Cmd.batch
        [ Cmd.map TeamsReceived Api.getAllTeams ]
    )



-- UPDATE


type Msg
    = TeamsReceived (Api.GraphqlData Api.Teams)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamsReceived teams ->
            ( { model | teams = teams }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    { title = "Teams"
    , body =
        [ el [ Region.heading 1, Font.size 25 ] (text "Teams")
        , teamsResponse model.teams
        ]
    }


teamsResponse : GraphqlData Teams -> Element msg
teamsResponse response =
    case response of
        NotAsked ->
            text "Not asked for teams yet"

        Loading ->
            text "Loading teams"

        Failure err ->
            text "Error!"

        Success teams ->
            List.map teamView teams
                |> column []


teamView : Team -> Element msg
teamView team =
    text ("Team: " ++ team.name ++ " with id " ++ team.id)
