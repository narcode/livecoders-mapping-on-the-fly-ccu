module Answers exposing (..)

import Dict exposing (Dict)
import Json.Encode as E
import Json.Decode as D
import List

type alias Model = 
    { answers : Dict String String
    , checkboxes : Dict String (List String) }

type alias Response = 
    { id : Int 
    , branch : String
    , answers : Model
    }

initAnswers : Model 
initAnswers = { answers = Dict.empty, checkboxes = Dict.empty }

insertAnswer : Int -> String -> Model -> Model 
insertAnswer num val model = 
    let
        key = String.fromInt num
    in
    { model | answers = Dict.insert key val model.answers }

appendAnswer : String -> String -> Model -> Model
appendAnswer key val model = 
    { model | answers = Dict.insert key val model.answers }    


insertCheckbox : Int -> String -> Model -> Model 
insertCheckbox num val model = 
    let
        key = String.fromInt num
        newlist = List.append [val] <| getcheckbox key model
    in
    { model | checkboxes = Dict.insert key newlist model.checkboxes }

removeCheckbox : Int -> String -> Model -> Model 
removeCheckbox num val model = 
    let
        key = String.fromInt num
        list = List.filter (\x -> x /= val) <| getcheckbox key model 

    in
    { model | checkboxes = Dict.insert key list model.checkboxes }

getcheckbox : String -> Model -> List String 
getcheckbox key a =
    Maybe.withDefault [] <| Dict.get key a.checkboxes

getAnswer : Int -> Model -> String 
getAnswer num a =
    let
        key = String.fromInt num
    in
    Maybe.withDefault "" <| Dict.get key a.answers

getAnswerS : String -> Model -> String 
getAnswerS key a =
    Maybe.withDefault "" <| Dict.get key a.answers          

encodeAnswer : Int -> Model -> E.Value
encodeAnswer num model = 
    let
        key = String.fromInt num
        answer = Maybe.withDefault "" <| Dict.get key model.answers
    in
    E.object [ ( "a", E.string answer ) ]

encodeAnswers : String -> Int -> Model -> E.Value
encodeAnswers branch formid model =
    E.object [
        ( "branch", E.string branch )
        , ( "id", E.int formid )
        , ( "answers", parseAnswers model.answers )
        , ( "checkboxes", parseCheckboxes model.checkboxes )
    ]    

parseAnswers : Dict String String -> E.Value
parseAnswers dict = 
   E.object <| List.map (\(k,v) -> (k, E.string v) ) (Dict.toList dict)

parseCheckboxes : Dict String (List String) -> E.Value
parseCheckboxes dict =
    E.object <| List.map (\(k, v) -> (k, E.string <| makeString v "") ) (Dict.toList dict)
    
makeString : List String -> String -> String
makeString list string = 
    ""
    -- if List.isEmpty list then 
    --     string 
    -- else 
    --     case list of 
    --         [] -> "empty"
    --         x :: xs -> makeString xs ("" ++ x) 

typeInput : Int -> String -> String 
typeInput num branch =
    case branch of 
        "Practitioners and Artists" -> 
            case num of 
                4 -> "radio"
                14 -> "radio"
                15 -> "radio"
                17 -> "radio"
                23 -> "radio"
                24 -> "checkbox" 
                _ -> "input"
        _ -> 
            case num of 
                8 -> "radio"
                9 -> "radio"
                11 -> "radio"
                12 -> "checkbox" 
                _ -> "input"


getOptions : Int -> String -> List String
getOptions num branch = 
    case branch of 
        "Practitioners and Artists" -> 
            case num of 
                4 -> [ "Audio & Music"
                    , "Visuals"
                    , "Music & Visuals"
                    , "Other"
                    ]
                14 -> [ "I don’t know others to practice with, yet" 
                    , "Online" 
                    , "Offline" 
                    , "Other"
                    ]
                15 -> [ "I don’t share this interest with others, yet"
                    , "Family"
                    , "Friends"
                    , "Colleagues (at work)"
                    , "Colleagues (at school)"
                    , "Colleagues (university)"
                    , "A collective"
                    , "Other"
                    ]
                24 -> 
                    [ "Receive news about the On-The-Fly Project"
                    , "Receive the CCU newsletter"
                    , "Connect with forum.toplap.org"
                    ]
                _ -> [ "yes", "no" ]

        _ ->     
            case num of 
                8 -> [ "I don't share this interest with others yet"
                    , "Family"
                    , "Friends"
                    , "Colleagues (at work)"
                    , "Colleagues (at school)"
                    , "Colleagues (university)"
                    , "A collective"
                    , "Other"
                    ]
                12 -> 
                    [ "Receive news about the On-The-Fly Project"
                    , "Receive the CCU newsletter"
                    , "Connect with forum.toplap.org"
                    ]
                _ -> [ "yes", "no" ]

getSecondaryInput : Int -> String -> String -> String 
getSecondaryInput num option branch =
    case branch of 
        "Practitioners and Artists" -> 
            case num of
                4 -> 
                    case option of
                        "Other" -> "Please describe" 
                        _ -> "" 
                14 -> 
                    case option of 
                        "Other" -> "Please describe"
                        "Online" -> "Please indicate your favourite online places"
                        "Offline" -> "Please indicate your favourite places"
                        _ -> "" 
                15 -> 
                    case option of
                        "Colleagues (at work)" -> "Which profession do you follow?" 
                        "Colleagues (at school)" -> "Which courses do you teach?"
                        "Colleagues (university)" -> "Which courses do you teach? Are they related to live coding?"
                        "A collective" -> "Do you have a website/social media channel where we can have a look at your work?"
                        "Other" -> "Please describe" 
                        _ -> "" 
                17 -> 
                    case option of 
                        "yes" -> "Where did it (they) take place?"
                        "no" -> "Would you like to do so? If so, what kind of venues would you imagine yourself to perform in?"
                        _ -> ""
                23 -> 
                    case option of 
                        "yes" -> "Please share your e-mail address with us, so we can get in contact with you"
                        _ -> ""                        
                _ -> ""

        _ -> 
            case num of
                8 -> 
                    case option of
                        "Colleagues (at work)" -> "Which profession do you follow?" 
                        "Colleagues (at school)" -> "Which courses do you teach?"
                        "Colleagues (university)" -> "Which courses do you teach? Are they related to live coding?"
                        "A collective" -> "Do you have a website/social media channel where we can have a look at your work?"
                        "Other" -> "Please describe" 
                        _ -> "" 
                9 -> 
                    case option of 
                        "yes" -> "where did it (they) take place?"
                        _ -> ""
                11 -> 
                    case option of 
                        "yes" -> "please share your e-mail address with us, so we can get in contact with you:"
                        _ -> ""
                        
                _ -> ""

decode : D.Decoder Response
decode = 
    D.map3 Response 
        ( D.field "id" D.int )
        ( D.field "branch" D.string )
        ( D.field "answers" decodeAnswers )

decodeAnswers : D.Decoder Model 
decodeAnswers = 
    D.map2 Model 
        ( D.field "answers" (D.dict D.string) )
        ( D.field "checkboxes" (D.dict <| D.list D.string) )
