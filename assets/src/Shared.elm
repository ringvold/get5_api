module Shared exposing
    ( Flags
    , Model
    , Msg
    , graphDataView
    , init
    , subscriptions
    , update
    , view
    )

import Api exposing (GraphqlData)
import Browser.Navigation exposing (Key)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import RemoteData exposing (RemoteData(..))
import Spa.Document exposing (Document)
import Spa.Generated.Route as Route
import Styling.Colors exposing (..)
import Url exposing (Url)



-- INIT


type alias Flags =
    ()


type alias Model =
    { url : Url
    , key : Key
    }


init : Flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model url key
    , Cmd.none
    )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


menuLinks : List (Attr decorative msg)
menuLinks =
    [ Font.color white
    , Font.size 20
    ]


view :
    { page : Document msg, toMsg : Msg -> msg }
    -> Model
    -> Document msg
view { page, toMsg } model =
    { title = page.title
    , body =
        [ column
            [ height fill
            , width fill
            ]
            [ row
                [ Background.color grey900
                , spacing 20
                , padding 20
                , width fill
                ]
                [ link
                    menuLinks
                    { url = Route.toString Route.Top, label = text "Homepage" }
                , link
                    menuLinks
                    { url = Route.toString Route.Teams, label = text "Teams" }
                , link
                    menuLinks
                    { url = Route.toString Route.Servers, label = text "Servers" }
                ]
            , column [ height fill, paddingXY 20 20 ] page.body
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
