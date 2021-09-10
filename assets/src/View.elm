module View exposing (View, graphDataView, map, none, placeholder, toBrowserDocument)

import Api exposing (GraphqlData)
import Browser
import Css
import Css.Global
import Gen.Route as Route
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import RemoteData exposing (RemoteData(..))
import Styling
import Styling.Colors as Colors


type alias View msg =
    { title : String
    , body : List (Html msg)
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , body = [ Html.text str ]
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , body = List.map (Html.map fn) view.body
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body =
        [ Css.Global.global [ Css.Global.selector "body" [ Css.padding Css.zero, Css.margin Css.zero ] ]
        , Html.div
            [ Attr.css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                ]
            ]
            [ Html.header
                []
                [ Html.ul
                    [ Attr.css
                        [ Css.displayFlex
                        , Css.alignItems Css.center
                        , Css.listStyle Css.none
                        , Css.margin Css.zero
                        ]
                    ]
                    [ li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Home_ ] [ text "Homepage" ] ]
                    , li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Teams ] [ text "Teams" ] ]
                    , li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Servers ] [ text "Servers" ] ]
                    , Html.li
                        [ Attr.css
                            [ Css.marginLeft Css.auto ]
                        ]
                        []
                    ]
                ]
            , Html.main_
                [ Attr.css
                    [ Css.flexGrow <| Css.int 1
                    , Css.displayFlex
                    , Css.flexDirection Css.column
                    ]
                ]
                view.body
            , Html.footer
                []
                []
            ]
        ]
            |> List.map Html.toUnstyled
    }


graphDataView : (a -> Html msg) -> GraphqlData a -> Html msg
graphDataView successView graphData =
    case graphData of
        NotAsked ->
            div [] [ Html.text "Initializing" ]

        Loading ->
            div [] [ Styling.loader ]

        Failure error ->
            div [] [ Html.text "Error loading data from server" ]

        Success data ->
            successView data
