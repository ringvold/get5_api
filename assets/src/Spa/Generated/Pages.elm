module Spa.Generated.Pages exposing
    ( Model
    , Msg
    , init
    , load
    , save
    , subscriptions
    , update
    , view
    )

import Pages.Top
import Pages.NotFound
import Pages.Servers
import Pages.Teams
import Pages.Teams.Id_String
import Shared
import Spa.Document as Document exposing (Document)
import Spa.Generated.Route as Route exposing (Route)
import Spa.Page exposing (Page)
import Spa.Url as Url


-- TYPES


type Model
    = Top__Model Pages.Top.Model
    | NotFound__Model Pages.NotFound.Model
    | Servers__Model Pages.Servers.Model
    | Teams__Model Pages.Teams.Model
    | Teams__Id_String__Model Pages.Teams.Id_String.Model


type Msg
    = Top__Msg Pages.Top.Msg
    | NotFound__Msg Pages.NotFound.Msg
    | Servers__Msg Pages.Servers.Msg
    | Teams__Msg Pages.Teams.Msg
    | Teams__Id_String__Msg Pages.Teams.Id_String.Msg



-- INIT


init : Route -> Shared.Model -> ( Model, Cmd Msg )
init route =
    case route of
        Route.Top ->
            pages.top.init ()
        
        Route.NotFound ->
            pages.notFound.init ()
        
        Route.Servers ->
            pages.servers.init ()
        
        Route.Teams ->
            pages.teams.init ()
        
        Route.Teams__Id_String params ->
            pages.teams__id_string.init params



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update bigMsg bigModel =
    case ( bigMsg, bigModel ) of
        ( Top__Msg msg, Top__Model model ) ->
            pages.top.update msg model
        
        ( NotFound__Msg msg, NotFound__Model model ) ->
            pages.notFound.update msg model
        
        ( Servers__Msg msg, Servers__Model model ) ->
            pages.servers.update msg model
        
        ( Teams__Msg msg, Teams__Model model ) ->
            pages.teams.update msg model
        
        ( Teams__Id_String__Msg msg, Teams__Id_String__Model model ) ->
            pages.teams__id_string.update msg model
        
        _ ->
            ( bigModel, Cmd.none )



-- BUNDLE - (view + subscriptions)


bundle : Model -> Bundle
bundle bigModel =
    case bigModel of
        Top__Model model ->
            pages.top.bundle model
        
        NotFound__Model model ->
            pages.notFound.bundle model
        
        Servers__Model model ->
            pages.servers.bundle model
        
        Teams__Model model ->
            pages.teams.bundle model
        
        Teams__Id_String__Model model ->
            pages.teams__id_string.bundle model


view : Model -> Document Msg
view model =
    (bundle model).view ()


subscriptions : Model -> Sub Msg
subscriptions model =
    (bundle model).subscriptions ()


save : Model -> Shared.Model -> Shared.Model
save model =
    (bundle model).save ()


load : Model -> Shared.Model -> ( Model, Cmd Msg )
load model =
    (bundle model).load ()



-- UPGRADING PAGES


type alias Upgraded params model msg =
    { init : params -> Shared.Model -> ( Model, Cmd Msg )
    , update : msg -> model -> ( Model, Cmd Msg )
    , bundle : model -> Bundle
    }


type alias Bundle =
    { view : () -> Document Msg
    , subscriptions : () -> Sub Msg
    , save : () -> Shared.Model -> Shared.Model
    , load : () -> Shared.Model -> ( Model, Cmd Msg )
    }


upgrade : (model -> Model) -> (msg -> Msg) -> Page params model msg -> Upgraded params model msg
upgrade toModel toMsg page =
    let
        init_ params shared =
            page.init shared (Url.create params shared.key shared.url) |> Tuple.mapBoth toModel (Cmd.map toMsg)

        update_ msg model =
            page.update msg model |> Tuple.mapBoth toModel (Cmd.map toMsg)

        bundle_ model =
            { view = \_ -> page.view model |> Document.map toMsg
            , subscriptions = \_ -> page.subscriptions model |> Sub.map toMsg
            , save = \_ -> page.save model
            , load = \_ -> load_ model
            }

        load_ model shared =
            page.load shared model |> Tuple.mapBoth toModel (Cmd.map toMsg)
    in
    { init = init_
    , update = update_
    , bundle = bundle_
    }


pages :
    { top : Upgraded Pages.Top.Params Pages.Top.Model Pages.Top.Msg
    , notFound : Upgraded Pages.NotFound.Params Pages.NotFound.Model Pages.NotFound.Msg
    , servers : Upgraded Pages.Servers.Params Pages.Servers.Model Pages.Servers.Msg
    , teams : Upgraded Pages.Teams.Params Pages.Teams.Model Pages.Teams.Msg
    , teams__id_string : Upgraded Pages.Teams.Id_String.Params Pages.Teams.Id_String.Model Pages.Teams.Id_String.Msg
    }
pages =
    { top = Pages.Top.page |> upgrade Top__Model Top__Msg
    , notFound = Pages.NotFound.page |> upgrade NotFound__Model NotFound__Msg
    , servers = Pages.Servers.page |> upgrade Servers__Model Servers__Msg
    , teams = Pages.Teams.page |> upgrade Teams__Model Teams__Msg
    , teams__id_string = Pages.Teams.Id_String.page |> upgrade Teams__Id_String__Model Teams__Id_String__Msg
    }