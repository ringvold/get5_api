module Pages.Teams exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Teams exposing (Params)
import Gen.Route as Route exposing (Route(..))
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
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
        { init = init shared
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { teams : GraphqlData Teams }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { teams = Loading }
    , Cmd.batch
        [ Cmd.map TeamsReceived <| Api.getAllTeams shared.baseUrl ]
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
    , body =
        [ h1 [] [ text "Teams" ]
        , View.graphDataView viewTeams model.teams
        ]
    }


viewTeams : Teams -> Html msg
viewTeams teams =
    List.map teamView teams
        |> div []


teamView : Team -> Html msg
teamView team =
    a [ Attr.href <| Route.toHref (Route.Teams__Id_ { id = team.id }) ]
        [ text team.name ]
