module Pages.Teams exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Teams exposing (Params)
import Gen.Route as Route exposing (Route(..))
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Html.Styled.Events as Events
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Styling
import Tailwind.Utilities as Tw
import Team exposing (Team, Teams)
import TeamId exposing (TeamId)
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
    | DeleteTeamClicked TeamId
    | TeamDeletedReceived (Api.GraphqlData (Maybe Team))


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        TeamsReceived teams ->
            ( { model | teams = teams }, Cmd.none )

        DeleteTeamClicked id ->
            ( model
            , Cmd.batch
                [ Api.deleteTeam shared.baseUrl id
                    |> Cmd.map TeamDeletedReceived
                ]
            )

        TeamDeletedReceived _ ->
            ( model, Cmd.map TeamsReceived <| Api.getAllTeams shared.baseUrl )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Teams"
    , body =
        [ h1 [ Styling.header ]
            [ text "Teams"
            , a
                [ Attr.href <| Route.toHref Route.Teams__New
                , Styling.header_inline_link
                ]
                [ text "New team" ]
            ]
        , View.graphDataView viewTeams model.teams
        ]
    }


viewTeams : Teams -> Html Msg
viewTeams teams =
    List.map teamView teams
        |> div []


teamView : Team -> Html Msg
teamView team =
    div []
        [ a
            [ Attr.href <| Route.toHref (Route.Teams__Id_ { id = TeamId.toString team.id })
            , Attr.css
                []
            ]
            [ text team.name ]
        , button
            [ Events.onClick <| DeleteTeamClicked team.id
            , Attr.css
                [ Tw.pl_1
                , Tw.cursor_pointer
                ]
            ]
            [ text "Delete" ]
        ]
