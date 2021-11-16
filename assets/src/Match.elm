module Match exposing (Match, MatchLight, Matches)

import Team exposing (Team)


type alias Matches =
    List Match


type alias Match =
    { id : String
    , team1 : Team
    , team2 : Team
    , seriesType : String
    , status : String
    }


type alias MatchLight =
    { id : String
    , seriesType : String
    , status : String
    }
