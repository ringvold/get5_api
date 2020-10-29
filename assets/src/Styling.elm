module Styling exposing (..)

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region


link : List (Attr () msg)
link =
    [ Font.color (rgb 0 0.25 0.5), Font.underline ]
