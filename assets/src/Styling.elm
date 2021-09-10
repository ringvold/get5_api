module Styling exposing (..)

import Css
import Css.Animations
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr
import Styling.Colors exposing (..)


menuLinks : Html.Attribute msg
menuLinks =
    Attr.css
        [ Css.padding <| Css.em 1
        ]


load : Css.Animations.Keyframes {}
load =
    Css.Animations.keyframes
        [ ( 0, [ Css.Animations.transform [ Css.rotate <| Css.deg 0 ] ] )
        , ( 100, [ Css.Animations.transform [ Css.rotate <| Css.deg 360 ] ] )
        ]


loader : Html msg
loader =
    Html.div
        [ Attr.css
            [ Css.borderRadius <| Css.pct 50
            , Css.height <| Css.rem 5
            , Css.width <| Css.rem 5
            , Css.position Css.relative
            , Css.border3 (Css.rem 0.5) Css.solid (Css.hex "efefef")
            , Css.borderLeft3 (Css.rem 0.5) Css.solid (Css.hex "eeeeee")
            , Css.transform <| Css.translateZ Css.zero
            , Css.animationName load
            , Css.animationDuration <| Css.sec 1.1
            , Css.property "animation-timing-function" "linear"
            , Css.property "animation-iteration-count" "infinite"
            ]
        ]
        []
