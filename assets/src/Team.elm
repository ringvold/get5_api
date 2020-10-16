module Team exposing (..)


type alias Teams =
    List Team


type alias Team =
    { id : String
    , name : String
    , players : List Player
    }


type alias Player =
    { id : String
    , name : Maybe String
    }
