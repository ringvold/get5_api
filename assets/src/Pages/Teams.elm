module Pages.Teams exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Element exposing (..)
import Element.Font as Font
import Element.Region as Region
import Gen.Params.Teams exposing (Params)
import Gen.Route as Route exposing (Route(..))
import Page
import RemoteData exposing (RemoteData(..), WebData)
import Request
import Shared
import Styling
import Team exposing (Team, Teams)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { teams : GraphqlData Teams }


init : ( Model, Cmd Msg )
init =
    ( { teams = Loading }
    , Cmd.batch
        [ Cmd.map TeamsReceived Api.getAllTeams ]
    )



-- UPDATE


type Msg
    = TeamsReceived (Api.GraphqlData Teams)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamsReceived teams ->
            ( { model | teams = teams }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Teams"
    , element =
        Element.column []
            [ el [ Region.heading 1, Font.size 25 ] (text "Teams")
            , View.graphDataView viewTeams model.teams
            ]
    }


viewTeams : Teams -> Element msg
viewTeams teams =
    List.map teamView teams
        |> column []


teamView : Team -> Element msg
teamView team =
    link Styling.link
        { url = Route.toHref (Route.Teams__Id_ { id = team.id })
        , label = text team.name
        }
