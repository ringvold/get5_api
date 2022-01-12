module Form exposing (..)

import Css
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw


textField : String -> String -> String -> (String -> msg) -> Html msg
textField name fieldLabel placeholder msg =
    fieldView "text" name fieldLabel placeholder msg


passwordField : String -> String -> String -> (String -> msg) -> Html msg
passwordField name fieldLabel placeholder msg =
    fieldView "password" name fieldLabel placeholder msg


fieldView : String -> String -> String -> String -> (String -> msg) -> Html msg
fieldView fieldType name fieldLabel placeholder msg =
    div
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
                , Attr.for name
                ]
                [ text fieldLabel ]
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
                , Attr.id name
                , Attr.type_ fieldType
                , Attr.placeholder placeholder
                , Events.onInput msg
                ]
                []
            ]
        ]


submitButton : Html msg
submitButton =
    div
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
            , Attr.type_ "submit"
            ]
            [ text "Create" ]
        ]
