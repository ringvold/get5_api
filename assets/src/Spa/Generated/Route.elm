module Spa.Generated.Route exposing
    ( Route(..)
    , fromUrl
    , toString
    )

import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Top
    | NotFound
    | Servers
    | Teams
    | Teams__New
    | Servers__Id_String { id : String }
    | Teams__Id_String { id : String }


fromUrl : Url -> Maybe Route
fromUrl =
    Parser.parse routes


routes : Parser (Route -> a) a
routes =
    Parser.oneOf
        [ Parser.map Top Parser.top
        , Parser.map NotFound (Parser.s "not-found")
        , Parser.map Servers (Parser.s "servers")
        , Parser.map Teams (Parser.s "teams")
        , Parser.map Teams__New (Parser.s "teams" </> Parser.s "new")
        , (Parser.s "servers" </> Parser.string)
          |> Parser.map (\id -> { id = id })
          |> Parser.map Servers__Id_String
        , (Parser.s "teams" </> Parser.string)
          |> Parser.map (\id -> { id = id })
          |> Parser.map Teams__Id_String
        ]


toString : Route -> String
toString route =
    let
        segments : List String
        segments =
            case route of
                Top ->
                    []
                
                NotFound ->
                    [ "not-found" ]
                
                Servers ->
                    [ "servers" ]
                
                Teams ->
                    [ "teams" ]
                
                Teams__New ->
                    [ "teams", "new" ]
                
                Servers__Id_String { id } ->
                    [ "servers", id ]
                
                Teams__Id_String { id } ->
                    [ "teams", id ]
    in
    segments
        |> String.join "/"
        |> String.append "/"