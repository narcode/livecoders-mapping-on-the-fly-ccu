module Questions exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { questions: Dict String String }

initEmpty : Model 
initEmpty = 
    { questions = Dict.empty }

initCCoders : Model 
initCCoders
    = { questions = Dict.fromList
    [ -- Part.1 general information: 
    ("1", "Do you have a country of residence? If yes, please indicate:")
    , ("2"  , "Which pronoun do you most identify with?" )
    , ("3", "Which disciplines you most relate with?" )
    -- Part 2: live coding: tools & gadgets
    , ("4", "Which keywords define your practice?")
    , ("5", "Which tools do you use?")
    , ("6", "Do you have an organization you want to add to the database?")
    , ("7", "Do you have an event you want to add to the database?")
    , ("8", "Do you have a venue (museum, gallery, etc.) you want to add to the database?")
    , ("9", "Would you like to be part of our database? This means the information you give us will show in our platform")
    , ("10", "What will you consider yourself?")
    , ("11", "What is your name/nickname?")
    , ("12", "please add a link to your personal website or social media")
    , ("13", "please add links to images/texts/websites that you would like to share publicly (projects, inspiration, funny memes, etc.)")
    ] 
    }    

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
    , ("7", "Which tools do you mostly use when live coding? (max. 50 words)")
    , ("8", "What live coding language/environment do you use and why? (max. 250 words)")
    , ("9", "Please provide links to the live coding tools mentioned above? (max 250 words)")
    , ("10", "Have you been involved in artistic projects yourself that you would like to share? (links, brief description) (max 250 words)")
    , ("11", "Are you part of a group or bands that do live coding together on stage? (links, brief description) (max 250 words)")
    -- Part.3: live coding background
    , ("12", "What inspired you to start live coding and what stimulates you continuing with it? (max. 250 words)")
    , ("13", "What is your aim as a live coder? (max. 250 words)")
    -- Part 4: live coding community
    , ("14", "Where do you practice live coding with peers?")
    , ("15", "Whom do you share your interest in live coding with?")
    -- Part 5: performance and events
    , ("16", "How much time/week do you dedicate to your live coding practise?")
    , ("17", "Did you have the chance to perform live coding practice in public?")
    , ("18", "What is important for you in terms of a performance space? (max. 50 words)")
    , ("19", "What is important for you in terms of performance facilities? (max. 50 words)")
    , ("20", "What is important for you in terms of technical equipment and opportunities? (max. 50 words)")
    , ("21", "Can you think of places you’ve visited when seeing other live coding performances? (online/offline) (max. 50 words)")
    -- Part 6: contact
    , ("22", "Do you have a website or a social media channel or both?")
    , ("23", "Would you like to have a conversation about the live coding practice and community with one of us? In this case we would like to conduct an *interview with you")
    , ("24", "If you want to keep in touch or stay up to date you can choose to:" )
    ] 
    }    

initAudience : Model
initAudience 
    = { questions = Dict.fromList
    [ -- Part.1 Audience experience:
    ("1", "Which live coding event are you attending (or the last one you have attended)?")
    , ("2"  ,"What was the last live coding event you attended? Where did it take place?" )
    , ("3", "Who told you about this event?" )
    , ("4", "How did you find out about this event?" )
    , ("5", "How long have you known about Live Coding?" )
    , ("6", "How many live coding events have you attended (both face-to-face and online)?" )
    , ("7", "How has your interest in live coding evolved after attending the last event?" )
    , ("8", "How likely would you recommend a friend or colleague to attend a live coding event?" )
    , ("9", "What is your overall level of satisfaction with the last live coding event you attended?" )
    -- Part 2: interests
    , ("10", """Live coding can be an entertaining experimental activity (to have a good time, socialize, to dance, etc.) and at the same time it can generate a 
            mainly technical interest in the audience (programming, computing, etc.)...
            What is your level of interest in the programming aspect of livecoding?""" )
    , ("11", "Which of the following musical genres do you most identify with?" )
    , ("12", "Do you program yourself?" )
    , ("13", "Have you ever considered practicing Live Coding?" )
    , ("14", """"On the fly" live coding project intends to develop and strengthen the European live 
        coding community and increase livecoding audience and interest in this practices. If you want to, please comment very briefly what 
        strategies or key actions you think can stimulate this growth:""" )
    -- Part 3. Sociodemographic
    , ("15", "What is your gender?" )
    , ("16", "When were you born?" )
    , ("17", "What country do you live in?" )
    , ("18", "What is your level of education that you have completed?")
    , ("19", "Which is the main branch of studies you are related to?")
    , ("20", "What branch is your work linked to?")
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

                _ -> ""

maxWords : Int -> String -> Int 
maxWords num branch =
    case branch of 
        "Practitioners and Artists" -> 
            case num of 
                5 -> 250
                7 -> 50
                8 -> 250
                9 -> 250
                10 -> 250
                11 -> 250
                12 -> 250
                13 -> 250
                18 -> 50
                19 -> 50
                20 -> 50
                21 -> 50
                _ -> 0
        "Institutions" -> 
            case num of 
                8 -> 100
                10 -> 250
                11 -> 250
                _ -> 0
        _ -> 
            case num of 
                13 -> 250
                14 -> 250
                _ -> 0