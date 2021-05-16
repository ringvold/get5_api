module View exposing (View, graphDataView, map, none, placeholder, toBrowserDocument)

import Api exposing (GraphqlData)
import Browser
import Element exposing (..)
import Element.Background as Background
import Gen.Route as Route
import RemoteData exposing (RemoteData(..))
import Styling
import Styling.Colors as Colors


type alias View msg =
    { title : String
    , element : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , element = Element.text str
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , element = Element.map fn view.element
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ Element.layout [] <|
            column
                [ height fill
                , width fill
                ]
                [ row
                    [ Background.color Colors.grey900
                    , spacing 20
                    , padding 20
                    , width fill
                    ]
                    [ link
                        Styling.menuLinks
                        { url = Route.toHref Route.Home_, label = text "Homepage" }
                    , link
                        Styling.menuLinks
                        { url = Route.toHref Route.Teams, label = text "Teams" }
                    , link
                        Styling.menuLinks
                        { url = Route.toHref Route.Servers, label = text "Servers" }
                    ]
                , column [ height fill, paddingXY 20 20 ] [ view.element ]
                ]
        ]
    }


graphDataView : (a -> Element msg) -> GraphqlData a -> Element msg
graphDataView successView graphData =
    case graphData of
        NotAsked ->
            text "Initializing"

        Loading ->
            text "Loading"

        Failure error ->
            text "Error loading data from server"

        Success data ->
            successView data
