module Pages.Teams.New exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Css
import Gen.Params.Teams.New exposing (Params)
import Gen.Route as Route
import Graphql.Http exposing (Error)
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
import Team exposing (Team)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias GraphqlMutationData a =
    RemoteData (Error (Maybe a)) (Maybe a)



-- INIT


type alias Model =
    { baseUrl : String
    , createdTeam : GraphqlMutationData Team
    , nameInput : String
    }


init : Shared.Model -> ( Model, Cmd Msg )
init shared =
    ( { createdTeam = NotAsked
      , nameInput = ""
      , baseUrl = shared.baseUrl
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = TeamCreated (GraphqlMutationData Team)
    | NameChanged String
    | SubmitTriggered


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TeamCreated result ->
            ( { model | createdTeam = result }, Cmd.none )

        NameChanged string ->
            ( { model | nameInput = string }, Cmd.none )

        SubmitTriggered ->
            ( model
            , Cmd.map TeamCreated <|
                Api.createTeam model.baseUrl { name = model.nameInput }
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Create team"
    , body =
        [ View.graphDataView2 successView preSubmit model.createdTeam ]
    }


preSubmit =
    div []
        [ h1 [ Styling.header ] [ text "Create team" ]
        , form
            [ Attr.css [ Tw.w_full, Tw.max_w_sm ]
            , Events.onSubmit SubmitTriggered
            ]
            [ div
                [ Attr.css [ Breakpoints.md [ Tw.flex, Tw.items_center, Tw.mb_6 ] ]
                ]
                [ div
                    [ Attr.css [ Breakpoints.md [ Tw.w_1over3 ] ]
                    ]
                    [ label
                        [ Attr.css
                            [ Tw.block
                            , Tw.text_gray_500
                            , Tw.mb_1
                            , Tw.pr_4
                            , Breakpoints.md [ Tw.text_right, Tw.mb_0 ]
                            ]
                        , Attr.for "team-name"
                        ]
                        [ text "Name" ]
                    ]
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    ]
                    [ input
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
                            , Css.focus [ Tw.outline_none, Tw.bg_white, Tw.border_green_500 ]
                            ]
                        , Attr.id "team-name"
                        , Attr.type_ "text"
                        , Attr.placeholder "Team Name"
                        , Events.onInput NameChanged
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.css [ Breakpoints.md [ Tw.flex, Tw.items_center ] ]
                ]
                [ div
                    [ Attr.css [ Breakpoints.md [ Tw.w_1over3 ] ]
                    ]
                    []
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    ]
                    [ button
                        [ Attr.css
                            [ Breakpoints.md [ Tw.w_2over3 ]
                            , Tw.shadow
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
                        [ text "Create" ]
                    ]
                ]
            ]
        ]


successView : Maybe Team -> Html msg
successView mteam =
    case mteam of
        Just team ->
            a
                [ Attr.href <| Route.toHref (Route.Teams__Id_ { id = team.id })
                , Attr.css
                    [ Tw.block ]
                ]
                [ text team.name ]

        Nothing ->
            div [] [ text "Could not create team" ]
