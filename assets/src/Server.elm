module Server exposing (..)


type alias Servers =
    List Server


type alias Server =
    { id : String
    , name : String
    , host : String
    , port_ : String
    , inUse : Bool
    }
