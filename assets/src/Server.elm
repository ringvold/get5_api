module Server exposing (Server, ServerLight, Servers)

import ServerId exposing (ServerId)


type alias Servers =
    List Server


type alias Server =
    { id : ServerId
    , name : String
    , host : String
    , port_ : String
    , inUse : Bool
    }


type alias ServerLight =
    { id : ServerId
    , name : String
    }
