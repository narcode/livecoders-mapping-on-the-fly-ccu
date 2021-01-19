module Answers exposing (..)

import Dict exposing (Dict)

type alias Model = 
    { answers : Dict String String }

initAnswers : Model 
initAnswers = { answers = Dict.empty }

insertAnswer : Int -> String -> Model -> Model 
insertAnswer num val model = 
    let
        key = String.fromInt num
    in
    { answers = Dict.insert key val model.answers }

getAnswer : Int -> Model -> String 
getAnswer num a =
    let
        key = String.fromInt num
    in
    Maybe.withDefault "" <| Dict.get key a.answers    