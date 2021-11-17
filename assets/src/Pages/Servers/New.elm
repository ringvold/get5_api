module Pages.Servers.New exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Css
import Gen.Params.Servers.New exposing (Params)
import Gen.Route as Route
import Graphql.Http exposing (Error)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Server exposing (Server)
import ServerId exposing (ServerId)
import Shared
import Styling
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req
        , update = update req
        , view = view
        , subscriptions = subscriptions
        }


type alias GraphqlMutationData a =
    RemoteData (Error ()) (Maybe a)



-- INIT


type alias Model =
    { baseUrl : String
    , createdServer : GraphqlMutationData Server
    , formInput : FormInput
    }


type alias FormInput =
    { name : String
    , host : String
    , port_ : String
    , password : String
    }


type Field
    = Name
    | Host
    | Port
    | Password


init : Shared.Model -> Request.With Params -> ( Model, Cmd Msg )
init shared req =
    ( { createdServer = NotAsked
      , formInput = emtpyForm
      , baseUrl = shared.baseUrl
      }
    , Cmd.none
    )


emtpyForm =
    { name = ""
    , host = ""
    , port_ = ""
    , password = ""
    }



-- UPDATE


type Msg
    = ServerCreated (GraphqlMutationData Server)
    | FieldChanged Field String
    | SubmitTriggered


update : Request.With Params -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        ServerCreated (Success (Just server)) ->
            ( model
            , Request.pushRoute (Route.Servers__Id_ { id = ServerId.toString server.id }) req
            )

        ServerCreated result ->
            ( { model | createdServer = result }, Cmd.none )

        FieldChanged field string ->
            let
                newFormInput =
                    case field of
                        Name ->
                            model.formInput
                                |> setName string

                        Host ->
                            model.formInput
                                |> setHost string

                        Port ->
                            model.formInput
                                |> setPort string

                        Password ->
                            model.formInput
                                |> setPassword string
            in
            ( { model | formInput = newFormInput }, Cmd.none )

        SubmitTriggered ->
            ( model
            , Cmd.map ServerCreated <|
                Api.createServer model.baseUrl model.formInput
            )


setName : String -> FormInput -> FormInput
setName newName formInput =
    { formInput | name = newName }


setHost : String -> FormInput -> FormInput
setHost newHost formInput =
    { formInput | host = newHost }


setPort : String -> FormInput -> FormInput
setPort newPort formInput =
    { formInput | port_ = newPort }


setPassword : String -> FormInput -> FormInput
setPassword newPassword formInput =
    { formInput | password = newPassword }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Create server"
    , body =
        [ View.graphDataView2 successView preSubmit model.createdServer ]
    }


preSubmit : Html Msg
preSubmit =
    div []
        [ h1 [ Styling.header ] [ text "Create server" ]
        , form
            [ Attr.css [ Tw.w_full, Tw.max_w_sm ]
            , Events.onSubmit SubmitTriggered
            ]
            [ textField "name" "Name" "Server Name" Name
            , textField "host" "Host" "IP address or domain name" Host
            , textField "port" "Port" "Port" Port
            , passwordField "password" "Password" "RCON password" Password
            , div
                [ Attr.css [ Breakpoints.md [ Tw.flex, Tw.items_center ] ]
                ]
                [ div
                    [ Attr.css [ Breakpoints.md [ Tw.w_1over3 ] ]
                    ]
                    []
                , submitButton
                ]
            ]
        ]


successView : Maybe Server -> Html msg
successView mteam =
    case mteam of
        Just server ->
            a
                [ Attr.href <| Route.toHref (Route.Servers__Id_ { id = ServerId.toString server.id })
                , Attr.css
                    [ Tw.block ]
                ]
                [ text server.name ]

        Nothing ->
            div [] [ text "Could not create server" ]


textField : String -> String -> String -> Field -> Html Msg
textField name fieldLabel placeholder msg =
    fieldView "text" name fieldLabel placeholder msg


passwordField : String -> String -> String -> Field -> Html Msg
passwordField name fieldLabel placeholder msg =
    fieldView "password" name fieldLabel placeholder msg


fieldView : String -> String -> String -> String -> Field -> Html Msg
fieldView fieldType name fieldLabel placeholder field =
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
                , Events.onInput (FieldChanged field)
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
