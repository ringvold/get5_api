module Pages.Matches exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Gen.Params.Teams exposing (Params)
import Gen.Route as Route exposing (Route(..))
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr exposing (..)
import Html.Styled.Events as Events
import Match exposing (Match, MatchLight, Matches)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Styling
import Tailwind.Utilities as Tw
import Team exposing (Team, Teams)
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
    { matches : GraphqlData (List MatchLight) }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { matches = Loading }
    , Cmd.batch
        [ Cmd.map MatchesReceived <| Api.getAllMatches shared.baseUrl ]
    )



-- UPDATE


type Msg
    = MatchesReceived (Api.GraphqlData (List MatchLight))


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        MatchesReceived matches ->
            ( { model | matches = matches }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Matches"
    , body =
        [ h1 [ Styling.header ]
            [ text "Matches"
            , a
                [ Attr.href <| Route.toHref Route.Matches__New
                , Styling.header_inline_link
                ]
                [ text "New match" ]
            ]
        , View.graphDataView matchesView model.matches
        ]
    }


matchesView : List MatchLight -> Html Msg
matchesView matches =
    List.map matchView matches
        |> div []


matchView : MatchLight -> Html Msg
matchView match =
    div []
        [ a
            [ Attr.href <| Route.toHref (Route.Matches__Id_ { id = match.id })
            , Attr.css
                [ Tw.block
                , Tw.cursor_pointer
                ]
            ]
            [ text match.id ]
        ]
