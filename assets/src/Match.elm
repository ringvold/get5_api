module Match exposing (Match, Matches)

import Team exposing (Team)


type alias Matches =
    List Match


type alias Match =
    { id : String
    , seriesType : String
    , status : String
    }
