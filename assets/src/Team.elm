module Team exposing (..)

import TeamId exposing (TeamId)


type alias Teams =
    List Team


type alias Team =
    { id : TeamId
    , name : String
    , players : List Player
    }


type alias TeamLight =
    { id : TeamId
    , name : String
    }


type alias Player =
    { id : String
    , name : Maybe String
    }
