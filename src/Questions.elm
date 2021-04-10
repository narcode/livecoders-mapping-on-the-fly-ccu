module Questions exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { questions: Dict String String }

initEmpty : Model 
initEmpty = 
    { questions = Dict.empty }

initArtist : Model 
initArtist 
    = { questions = Dict.fromList
    [ -- Part.1 general information: 
    ("1", "Do you have a country of residence? If yes, please indicate:")
    , ("2"  , "which gender do you most identify with?" )
    , ("3", "What’s your country of origin?" )
    -- Part 2: live coding: tools & gadgets
    , ("4", "What is your main discipline?")
    , ("5", "Can you frame a style/genre that best describes your work? (max. 250 words)")
    , ("6", "Here’s a little experiment: Can you describe your coding practise in five keywords?")
    , ("7", "Which tools do you mostly use when live coding?")
    , ("8", "What live coding language/environment do you use and why?")
    , ("9", "Please provide links to the live coding tools mentioned above?")
    , ("10", "Have you been involved in artistic projects yourself that you would like to share? (links, brief description)")
    , ("11", "Are you part of a group or bands that do live coding together on stage? (links, brief description)")
    -- Part.3: live coding background
    , ("12", "What inspired you to start live coding and what stimulates you continuing with it? (max. 250 words)")
    , ("13", "What is your aim as a live coder? Please, tell us more about this aspect below:")
    -- Part 4: live coding community
    , ("14", "Where do you practice live coding with peers?")
    , ("15", "Whom do you share your interest in live coding with?")
    -- Part 5: performance and events
    , ("16", "How much time/week do you dedicate to your live coding practise?")
    , ("17", "Did you have the chance to perform live coding practice in public?")
    , ("18", "What is important for you in terms of a performance space?")
    , ("19", "What is important for you in terms of performance facilities?")
    , ("20", "What is important for you in terms of technical equipment and opportunities?")
    , ("21", "Can you think of places you’ve visited when seeing other live coding performances? (online/offline)")
    -- Part 6: contact
    , ("22", "Do you have a website or a social media channel or both?")
    , ("23", "Would you like to have a conversation about the live coding practice and community with one of us? In this case we would like to conduct an *interview with you")
    , ("24", "If you want to keep in touch or stay up to date you can choose to:" )
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
    [ -- Part.1 general information:
    ("1", "What is the name of your organization?")
    , ("2"  , "Website:" )
    , ("3", "Where are you (physically) located?" )
    , ("4", "When has it been  established?" )
    , ("5", "What is your mode of operation?" )
    -- Part 2. Creative directions and live coding
    , ("6", "In which field are you operating? (choose as many)" )
    , ("7", "Can you select or add keywords that summarize themes of interest your organisation supports?" )
    , ("8", "Can you give us a brief description of your target audience? (max. 100 words)" )
    , ("9", "Are you familiar with live coding?" )
    , ("10", "Did you ever collaborate with live coders? If so, how and where did your collaboration take place? (max. 250 words)")
    , ("11", """What is the curatorial context/program in which you (would) contextualise the practice of live coding? (max. 250 words)
        For example: An Algorave presents live coding in the context of club music and visuals, A Shader Showdown is a contest focusing on excellency in making live computer graphics. 
        """)
    , ("12", "Would you be interested in collaborating with live coders? If so, what are the skills or areas of expertise that your organisation can/could offer to live coders?")
    , ("13", "Did you facilitate a live coding performance in an event you’ve hosted?")
    , ("14", "What kind of support could your organisation offer to the live coding practise?")
    -- Part 4. Contact
    , ("15", "We would like to continue this conversation and extend the scope to find out more about your activities in the live coding field. Would you like to have an interview with one of us in the upcoming weeks?")
    , ("16", "If you want to keep in touch or stay up to date you can choose to:" )
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

getQuestionExtra : Int -> String -> String 
getQuestionExtra num branch =
    case branch of 
        "Practitioners and Artists" -> 
            case num of
                23 -> """*We want to conduct interviews of 15-20 min. with live coding enthusiasts and practiconers to elaborate together how 
                    to best map out the live coding culture and draw connections between educational institutions, event venues, organisations and 
                    (becoming) artists in order to foster talent and nourish collaboration among like minds."""
                _ -> ""

        "Institutions" ->
            case num of 
                15 -> """*We want to conduct interviews of 15-20 min. with live coding enthusiasts and practiconers to elaborate together how 
                    to best map out the live coding culture and draw connections between educational institutions, event venues, organisations and 
                    (becoming) artists in order to foster talent and nourish collaboration among like minds."""
                _ -> ""

        _ -> 
            case num of
                11 -> """*We want to conduct interviews of 15-20 min. with live coding enthusiasts and practiconers to elaborate together how 
                    to best map out the live coding culture and draw connections between educational institutions, event venues, organisations and 
                    (becoming) artists in order to foster talent and nourish collaboration among like minds."""
                _ -> ""

maxWords : Int -> String -> Int 
maxWords num branch =
    case branch of 
        "Practitioners and Artists" -> 
            case num of 
                5 -> 250
                12 -> 250
                _ -> 0
        "Institutions" -> 
            case num of 
                8 -> 100
                10 -> 250
                11 -> 250
                _ -> 0
        _ -> 
            case num of 
                5 -> 250
                6 -> 250
                7 -> 250
                _ -> 0