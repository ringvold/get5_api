module Spa.Document exposing
    ( Document
    , map
    , toBrowserDocument
    )

import Browser
import Element exposing (..)
import Element.Background exposing (color)
import Styling.Colors exposing (..)


type alias Document msg =
    { title : String
    , body : List (Element msg)
    }


map : (msg1 -> msg2) -> Document msg1 -> Document msg2
map fn doc =
    { title = doc.title
    , body = List.map (Element.map fn) doc.body
    }


toBrowserDocument : Document msg -> Browser.Document msg
toBrowserDocument doc =
    { title = String.join "" [ doc.title, " - ", "Get5 UI" ]
    , body =
        [ Element.layout
            [ width fill
            , height fill
            , centerX
            , color grey100
            ]
            (column
                [ centerX
                , width (fill |> maximum 800)
                , height fill
                , color white
                ]
                doc.body
            )
        ]
    }
