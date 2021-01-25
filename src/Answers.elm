module Answers exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { answers : Dict String String
    , checkboxes : Dict String (List String) }

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

typeInput : Int -> String 
typeInput num = 
    case num of 
        8 -> "radio"
        9 -> "radio"
        11 -> "radio"
        12 -> "checkbox" 
        _ -> "input"


getOptions : Int -> List String
getOptions num = 
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

getSecondaryInput : Int -> String -> String 
getSecondaryInput num option =
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
