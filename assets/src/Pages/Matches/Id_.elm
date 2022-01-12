module Pages.Matches.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Matches.Id_ exposing (Params)
import Gen.Params.Servers.Id_ exposing (Params)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Match exposing (Match, Matches)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Styling
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
    { match : GraphqlData Match }


init : Shared.Model -> Params -> ( Model, Cmd Msg )
init shared params =
    ( { match = Loading }
    , Cmd.batch
        [ Cmd.map MatchReceived (Api.getMatch shared.baseUrl params.id)
        ]
    )



-- UPDATE


type Msg
    = MatchReceived (GraphqlData Match)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MatchReceived match ->
            ( { model | match = match }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title =
        RemoteData.map
            (\match ->
                match.team1.name ++ " vs " ++ match.team2.name
            )
            model.match
            |> RemoteData.withDefault "Unknown match"
    , body = [ View.graphDataView matchView model.match ]
    }


matchView : Match -> Html Msg
matchView match =
    div []
        [ h1 [ Styling.header ] [ text <| match.team1.name ++ " vs " ++ match.team2.name ]
        , div [] [ text ("Team1: " ++ match.team1.name) ]
        , div [] [ text ("Team2: " ++ match.team2.name) ]
        , div [] [ text ("Series type: " ++ Match.seriesTypeToString match.seriesType) ]
        , div [] [ text ("Server: " ++ match.server.name) ]
        ]


boolToString : Bool -> String
boolToString bool =
    if bool then
        "Yes"

    else
        "No"
