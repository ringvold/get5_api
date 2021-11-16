module View exposing (View, graphDataView, graphDataView2, map, none, placeholder, toBrowserDocument)

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
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw


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
        [ Css.Global.global
            [ Css.Global.selector "body" [ Css.padding Css.zero, Css.margin Css.zero ]
            ]
        , Css.Global.global Tw.globalStyles
        , Html.div
            [ Attr.css
                [ Css.displayFlex
                , Css.flexDirection Css.column
                , Breakpoints.lg
                    [ Tw.my_0
                    , Tw.mx_auto
                    , Tw.max_w_5xl
                    ]
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
                        , Tw.p_0
                        , Tw.bg_gray_800
                        ]
                    ]
                    [ li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Home_ ] [ text "Homepage" ] ]
                    , li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Teams ] [ text "Teams" ] ]
                    , li [ Styling.menuLinks ] [ a [ Attr.href <| Route.toHref Route.Matches ] [ text "Matches" ] ]
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
                    [ Breakpoints.lg [ Tw.mx_0 ]
                    , Tw.mx_5
                    , Css.flexGrow <| Css.int 1
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
    graphDataView2
        successView
        (div [] [ Html.text "Initializing" ])
        graphData


graphDataView2 successView notAskedView graphData =
    case graphData of
        NotAsked ->
            notAskedView

        Loading ->
            div [] [ Styling.loader ]

        Failure error ->
            div [ Styling.header ] [ Html.text "Error loading data from server" ]

        Success data ->
            successView data
