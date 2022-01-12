module Pages.Matches.New exposing (Model, Msg, page)

import Api exposing (GraphqlData)
import Css
import Form exposing (..)
import Gen.Params.Matches.New exposing (Params)
import Gen.Route as Route
import Graphql.Http exposing (Error)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes as Attr
import Html.Styled.Events as Events
import Match exposing (Match)
import Page
import RemoteData exposing (RemoteData(..))
import Request
import Select exposing (Action(..))
import Select.Styles as Styles
import Server exposing (ServerLight)
import Shared
import Styling
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Utilities as Tw
import Team exposing (TeamLight)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req
        , update = update req
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { baseUrl : String
    , createdMatch : Api.GraphqlMutationData Api.MatchPayload
    , formInput : FormInput
    , team1SelectState : Select.State
    , team2SelectState : Select.State
    , serverSelectState : Select.State
    , teamItems : List (Select.MenuItem TeamLight)
    , serverItems : List (Select.MenuItem ServerLight)
    }


type alias FormInput =
    { team1 : Maybe TeamLight
    , team2 : Maybe TeamLight
    , server : Maybe ServerLight
    , name : String
    }


type Field
    = Team1
    | Team2
    | Server


init : Shared.Model -> Request.With Params -> ( Model, Cmd Msg )
init shared req =
    ( { createdMatch = NotAsked
      , formInput = emtpyForm
      , baseUrl = shared.baseUrl
      , team1SelectState = Select.initState
      , team2SelectState = Select.initState
      , serverSelectState = Select.initState
      , teamItems = []
      , serverItems = []
      }
    , Cmd.batch
        [ Cmd.map TeamsReceived <| Api.getAllTeamsLight shared.baseUrl
        , Cmd.map ServersReceived <| Api.getAllServersLight shared.baseUrl
        ]
    )


emtpyForm =
    { team1 = Nothing
    , team2 = Nothing
    , server = Nothing
    , name = ""
    }



-- UPDATE


type Msg
    = MatchCreated (Api.GraphqlMutationData Api.MatchPayload)
    | TeamsReceived (Api.GraphqlData (List TeamLight))
    | ServersReceived (Api.GraphqlData (List ServerLight))
    | FieldChanged Field String
    | SelectMsg Field (Select.Msg TeamLight)
    | SelectServerMsg (Select.Msg ServerLight)
    | SubmitTriggered


update : Request.With Params -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        MatchCreated (Success (Just payload)) ->
            case payload.result of
                Just match ->
                    ( model
                    , Request.pushRoute (Route.Matches__Id_ { id = match.id }) req
                    )

                Nothing ->
                    ( model, Cmd.none )

        MatchCreated result ->
            ( { model | createdMatch = result }, Cmd.none )

        TeamsReceived teams ->
            let
                teamItems =
                    case teams of
                        Success teams_ ->
                            List.map
                                (\team ->
                                    { item = team, label = team.name }
                                )
                                teams_

                        _ ->
                            []
            in
            ( { model | teamItems = teamItems }, Cmd.none )

        ServersReceived servers ->
            let
                serverItems =
                    case servers of
                        Success servers_ ->
                            List.map
                                (\server ->
                                    { item = server, label = server.name }
                                )
                                servers_

                        _ ->
                            []
            in
            ( { model | serverItems = serverItems }, Cmd.none )

        FieldChanged field string ->
            --let
            --    newFormInput =
            --        case field of
            --            Team1 ->
            --                model.formInput
            --                    |> setTeam1 string
            --            Team2 ->
            --                model.formInput
            --                    |> setTeam2 string
            --in
            --( { model | formInput = newFormInput }, Cmd.none )
            ( model, Cmd.none )

        SelectServerMsg selectMsg ->
            let
                ( maybeAction, updatedSelectState, selectCmds ) =
                    Select.update selectMsg model.serverSelectState

                newModel =
                    case maybeAction of
                        Just (Select selected) ->
                            { model
                                | formInput =
                                    model.formInput
                                        |> setServer (Just selected)
                            }

                        Just ClearSingleSelectItem ->
                            { model
                                | formInput =
                                    model.formInput
                                        |> setServer Nothing
                            }

                        _ ->
                            model
            in
            ( { newModel | serverSelectState = updatedSelectState }
            , Cmd.map SelectServerMsg selectCmds
            )

        SelectMsg field selectMsg ->
            let
                ( maybeAction, updatedSelectState, selectCmds ) =
                    case field of
                        Team1 ->
                            Select.update selectMsg model.team1SelectState

                        Team2 ->
                            Select.update selectMsg model.team2SelectState

                        _ ->
                            ( Nothing, model.team1SelectState, Cmd.none )

                newModel =
                    case maybeAction of
                        Just (Select selected) ->
                            case field of
                                Team1 ->
                                    { model
                                        | team1SelectState = updatedSelectState
                                        , formInput =
                                            model.formInput
                                                |> setTeam1 (Just selected)
                                    }

                                Team2 ->
                                    { model
                                        | team2SelectState = updatedSelectState
                                        , formInput =
                                            model.formInput
                                                |> setTeam2 (Just selected)
                                    }

                                _ ->
                                    model

                        Just ClearSingleSelectItem ->
                            case field of
                                Team1 ->
                                    { model
                                        | team1SelectState = updatedSelectState
                                        , formInput =
                                            model.formInput
                                                |> setTeam1 Nothing
                                    }

                                Team2 ->
                                    { model
                                        | team2SelectState = updatedSelectState
                                        , formInput =
                                            model.formInput
                                                |> setTeam2 Nothing
                                    }

                                Server ->
                                    model

                        _ ->
                            case field of
                                Team1 ->
                                    { model | team1SelectState = updatedSelectState }

                                Team2 ->
                                    { model | team2SelectState = updatedSelectState }

                                _ ->
                                    model
            in
            ( newModel
            , Cmd.map (SelectMsg field) selectCmds
            )

        SubmitTriggered ->
            ( model
            , case
                ( model.formInput.team1
                , model.formInput.team2
                , model.formInput.server
                )
              of
                ( Just team1, Just team2, Just server ) ->
                    Cmd.map MatchCreated <|
                        Api.createMatch model.baseUrl
                            { team1 = team1.id
                            , team2 = team2.id
                            , serverId = server.id
                            , maps = [ "de_mirage" ]
                            }

                _ ->
                    Cmd.none
            )


setTeam1 : Maybe TeamLight -> FormInput -> FormInput
setTeam1 newTeam1 formInput =
    { formInput | team1 = newTeam1 }


setTeam2 : Maybe TeamLight -> FormInput -> FormInput
setTeam2 newTeam2 formInput =
    { formInput | team2 = newTeam2 }


setServer : Maybe ServerLight -> FormInput -> FormInput
setServer newServer formInput =
    { formInput | server = newServer }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Create match"
    , body =
        [ View.payloadView successView (preSubmit model) model.createdMatch ]
    }


preSubmit : Model -> Html Msg
preSubmit model =
    div []
        [ h1 [ Styling.header ] [ text "Create match" ]
        , form
            [ Attr.css [ Tw.w_full, Tw.max_w_sm ]
            , Events.onSubmit SubmitTriggered
            ]
            [ div
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
                        , Attr.for "Team1Selector"
                        ]
                        [ text "Team 1" ]
                    ]
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    ]
                    [ Html.map (SelectMsg Team1) (renderSelect model Team1)
                    ]
                ]
            , div
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
                        , Attr.for "Team2Selector"
                        ]
                        [ text "Team 2" ]
                    ]
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    ]
                    [ Html.map (SelectMsg Team2) (renderSelect model Team2)
                    ]
                ]
            , div
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
                        , Attr.for "ServerSelector"
                        ]
                        [ text "Server" ]
                    ]
                , div
                    [ Attr.css [ Breakpoints.md [ Tw.w_2over3 ] ]
                    ]
                    [ Html.map SelectServerMsg
                        (Select.view
                            ((Select.single <| Maybe.map selectedServerToMenuItem model.formInput.server)
                                |> Select.state model.serverSelectState
                                |> Select.menuItems model.serverItems
                                |> Select.placeholder "Select server"
                            )
                            (Select.selectIdentifier "ServerSelector")
                        )
                    ]
                ]
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


selectedTeamToMenuItem : TeamLight -> Select.MenuItem TeamLight
selectedTeamToMenuItem team =
    { item = team, label = team.name }


selectedServerToMenuItem : ServerLight -> Select.MenuItem ServerLight
selectedServerToMenuItem server =
    { item = server, label = server.name }


sameTeamPredicate : Maybe TeamLight -> Select.MenuItem TeamLight -> Bool
sameTeamPredicate team menuItem =
    case team of
        Just team_ ->
            team_.id /= menuItem.item.id

        Nothing ->
            True


renderSelect : Model -> Field -> Html (Select.Msg TeamLight)
renderSelect model field =
    let
        availableTeamItems team =
            List.filter (sameTeamPredicate team) model.teamItems
    in
    case field of
        Team1 ->
            Select.view
                ((Select.single <| Maybe.map selectedTeamToMenuItem model.formInput.team1)
                    |> Select.state model.team1SelectState
                    |> Select.menuItems (availableTeamItems model.formInput.team2)
                    |> Select.placeholder "Select team 1"
                    |> Select.clearable True
                )
                (Select.selectIdentifier "Team1Selector")

        Team2 ->
            Select.view
                ((Select.single <| Maybe.map selectedTeamToMenuItem model.formInput.team2)
                    |> Select.state model.team2SelectState
                    |> Select.menuItems (availableTeamItems model.formInput.team1)
                    |> Select.placeholder "Select team 2"
                    |> Select.clearable True
                )
                (Select.selectIdentifier "Team2Selector")

        _ ->
            text ""


successView : Maybe Match -> Html msg
successView mMatch =
    case mMatch of
        Just match ->
            a
                [ Attr.href <| Route.toHref (Route.Matches__Id_ { id = match.id })
                , Attr.css
                    [ Tw.block ]
                ]
                [ text match.id ]

        Nothing ->
            div [] [ text "Could not create match" ]
