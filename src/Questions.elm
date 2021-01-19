module Questions exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { questions: Dict String String }

initArtist : Model 
initArtist 
    = { questions = Dict.fromList
    [ ("1", "au question 1")
    , ("2"  , "au question 2" )
    , ("3", "au question 3" )
    ] 
    }    

initAudience : Model
initAudience 
    = { questions = Dict.fromList
    [ -- Part.1 general information:
    ("1", "Do you have a country of residence? If yes, please indicate:")
    , ("2"  , "For how long have you been living there?" )
    , ("3", "Which gender do you most identify with?" )
    , ("4", "What’s your country of origin?" )
    -- Part.2 live coding background:
    , ("5", "Why are you interested in live coding? How and where did this interest start to evolve? (max. 250 words)" )
    , ("6", "Would you like to do live coding as well or do you prefer to be a 'spectator of the happening'? (max. 250 words)" )
    -- Part 3: community
    , ("7", "Have you been in contact with a live coding community outside of your country of residence? Tell us about it! (max. 250 words)" )
    , ("8", "Whom do you share your interest in live coding with?" )
    -- Part 4: performance and events
    , ("9", "Did you ever attend a live coding event?" )
    ]
    }           

initInst : Model 
initInst 
    = { questions = Dict.fromList
    [ ("0", "continue")
    , ("1", "i question 1")
    , ("2"  , "i question 2" )
    , ("3", "i question 3" )
    ] 
    }    

getQuestion : Int -> Model -> String 
getQuestion num q =
    let
        key = String.fromInt num
    in
    Maybe.withDefault "" <| Dict.get key q.questions
    
