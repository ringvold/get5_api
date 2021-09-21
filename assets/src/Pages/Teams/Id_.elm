module Pages.Teams.Id_ exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Css
import Gen.Params.Teams.Id_ exposing (Params)
import Gen.Route as Route
import GetFiveApi.Object.Team exposing (players)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Shared
import Styling
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
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
    { team : GraphqlData Team
    , showForm : Bool
    }


init : Shared.Model -> Params -> ( Model, Cmd Msg )
init shared params =
    ( { team = Loading, showForm = False }
    , Cmd.batch
        [ Cmd.map TeamReceived (Api.getTeam shared.baseUrl params.id)
        ]
    )



-- UPDATE


type Msg
    = TeamReceived (GraphqlData Team)
    | ShowNewPlayerForm
    | PlayerIdChanged String
    | PlayerNameChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamReceived team ->
            ( { model | team = team }, Cmd.none )

        ShowNewPlayerForm ->
            ( { model | showForm = not model.showForm }, Cmd.none )

        PlayerIdChanged id ->
            ( model, Cmd.none )

        PlayerNameChanged id ->
            ( model, Cmd.none )



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
    , body = [ View.graphDataView (viewTeam model) model.team ]
    }


viewTeam : Model -> Team -> Html Msg
viewTeam model team =
    div
        []
        [ h1 [ Styling.header ]
            [ text team.name
            , button
                [ Events.onClick ShowNewPlayerForm
                , Attr.css
                    [ Tw.shadow
                    , Tw.bg_green_500
                    , Tw.cursor_pointer
                    , Tw.text_white
                    , Tw.text_xs
                    , Tw.font_bold
                    , Tw.py_1
                    , Tw.px_2
                    , Tw.rounded
                    , Tw.ml_3
                    , Css.focus [ Tw.outline_none ]
                    , Css.hover [ Tw.bg_green_400 ]
                    ]
                ]
                [ text "Add a player" ]
            ]
        , newPlayerView model.showForm
        , viewPlayers team
        ]


newPlayerView : Bool -> Html Msg
newPlayerView show =
    if show then
        form
            [ Attr.css
                [ Tw.mb_5
                , Tw.p_5
                , Tw.border_2
                ]
            ]
            [ div [ Attr.css [ Tw.font_bold, Tw.mb_2 ] ] [ text "New player" ]
            , input
                [ Attr.css
                    [ Breakpoints.md []
                    , Tw.bg_gray_200
                    , Tw.appearance_none
                    , Tw.border_2
                    , Tw.border_gray_200
                    , Tw.rounded
                    , Tw.w_full
                    , Tw.py_2
                    , Tw.px_4
                    , Tw.text_gray_700
                    , Tw.leading_tight
                    , Tw.mb_2
                    , Css.focus [ Tw.outline_none, Tw.bg_white, Tw.border_green_500 ]
                    ]
                , Attr.id "player-id"
                , Attr.type_ "text"
                , Attr.placeholder "Player SteamID"
                , Events.onInput PlayerIdChanged
                ]
                []
            , input
                [ Attr.css
                    [ Breakpoints.md []
                    , Tw.bg_gray_200
                    , Tw.appearance_none
                    , Tw.border_2
                    , Tw.border_gray_200
                    , Tw.rounded
                    , Tw.w_full
                    , Tw.py_2
                    , Tw.px_4
                    , Tw.text_gray_700
                    , Tw.leading_tight
                    , Tw.mb_2
                    , Css.focus [ Tw.outline_none, Tw.bg_white, Tw.border_green_500 ]
                    ]
                , Attr.id "player-name"
                , Attr.type_ "text"
                , Attr.placeholder "Player Name (Optional)"
                , Events.onInput PlayerNameChanged
                ]
                []
            , button
                [ Attr.css
                    [ Tw.shadow
                    , Tw.bg_green_500
                    , Tw.cursor_pointer
                    , Tw.text_white
                    , Tw.font_bold
                    , Tw.py_2
                    , Tw.px_4
                    , Tw.rounded
                    , Css.focus [ Tw.outline_none ]
                    , Css.hover [ Tw.bg_green_400 ]
                    ]
                , Attr.type_ "button"
                ]
                [ text "Add player" ]
            ]

    else
        text ""


viewPlayers : Team -> Html Msg
viewPlayers team =
    if List.isEmpty team.players then
        div []
            [ text "No players yet. Try adding a player."
            ]

    else
        team.players
            |> List.map
                (\player ->
                    case player.name of
                        Just name ->
                            div [] [ name ++ ": " ++ player.id |> text ]

                        Nothing ->
                            div [] [ "Steam ID: " ++ player.id |> text ]
                )
            |> List.append [ h1 [] [ text "Players:" ] ]
            |> div []
