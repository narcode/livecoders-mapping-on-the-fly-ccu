module Questions exposing (..)

type alias Model = 
    { questions: Questions }

type alias Questions = 
    { one: String
    , two: String
    }

initAudience : Model 
initAudience 
    = { questions = {
        one = "a question 1"
        , two = "a question 2"
        }
    }    

initArtist : Model
initArtist 
    = { questions = {
        one = "lc question 1"
        , two = "lc question 2"
        }
    }        

initInst : Model 
initInst 
    = { questions = {
        one = "i 1"
        , two = "i 2"
        }
    }
