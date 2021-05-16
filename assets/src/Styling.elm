module Styling exposing (..)

import Element exposing (..)
import Element.Font as Font
import Styling.Colors exposing (..)


link : List (Attr () msg)
link =
    [ Font.color (rgb 0 0.25 0.5), Font.underline ]


menuLinks : List (Attr decorative msg)
menuLinks =
    [ Font.color white
    , Font.size 20
    ]
