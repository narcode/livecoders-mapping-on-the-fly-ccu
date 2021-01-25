module Questions exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { questions: Dict String String }

initArtist : Model 
initArtist 
    = { questions = Dict.fromList
    [ ("1", "lc question 1")
    , ("2"  , "lc question 2" )
    , ("3", "lc question 3" )
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
    -- Part 5: contact
    , ("10", "Do you have a website or a social media account? Or both? You can indicate them here if you want:" )
    , ("11", "Would you like to have a conversation about the live coding practice and community with one of us? In this case we would like to conduct an *interview with you" )
    , ("12", "If you want to keep in touch or stay up to date you can choose to:" )
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

getQuestionS : String -> Model -> String 
getQuestionS key q =
    Maybe.withDefault "" <| Dict.get key q.questions


appendQuestion : String -> String -> Model -> Model
appendQuestion key val model = 
    { questions = Dict.insert key val model.questions }    