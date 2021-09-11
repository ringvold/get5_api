module Pages.Teams.New exposing (Model, Msg, page)

import Css
import Gen.Params.Teams.New exposing (Params)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Page
import Request
import Shared
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
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
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Create team"
    , body =
        [ h1 [] [ text "Create team" ]
        , form
            [ Attr.css [ Tw.w_full, Tw.max_w_sm ]
            ]
            [ div
                [ Attr.css [ Breakpoints.md [ Tw.flex, Tw.items_center, Tw.mb_6 ] ]
                ]
                [ div
                    [ Attr.css [ Breakpoints.md [ Tw.w_1over3 ] ]
                    ]
                    [ label
                        [ Attr.class "block text-gray-500 font-bold md:text-right mb-1 md:mb-0 pr-4"
                        , Attr.css
                            [ Tw.block
                            , Tw.text_gray_500
                            , Tw.text_right
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
                    , Attr.class "md:w-2/3"
                    ]
                    [ input
                        [ Attr.class "bg-gray-200 appearance-none border-2 border-gray-200 rounded w-full py-2 px-4 text-gray-700 leading-tight focus:outline-none focus:bg-white focus:border-purple-500"
                        , Attr.css
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
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.css [ Breakpoints.md [ Tw.flex, Tw.items_center ] ]
                , Attr.class "md:flex md:items-center"
                ]
                [ div
                    [ Attr.css [ Breakpoints.md [ Tw.w_1over3 ] ]
                    , Attr.class "md:w-1/3"
                    ]
                    []
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    , Attr.class "md:w-2/3"
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
                        , Attr.class "shadow bg-purple-500 hover:bg-purple-400 focus:shadow-outline focus:outline-none text-white font-bold py-2 px-4 rounded"
                        , Attr.type_ "button"
                        ]
                        [ text "Create" ]
                    ]
                ]
            ]
        ]
    }
