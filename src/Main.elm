module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, h2, h3, br, span , input)
import Html.Attributes as HA
import Html.Events exposing (onClick, onInput, on)
import Json.Decode as D
import Json.Encode as E
import Questions as Q
import Answers as A
import Html.Lazy as L
import String

---- MODEL ----


type alias Model =
    { branch: String 
    , formlink: String
    , questions: Q.Model
    , answers: A.Model
    , progress: Int
    , end: Int
    }


init : ( Model, Cmd Msg )
init =
    ( { branch = ""
    , formlink = ""
    , questions = Q.initAudience 
    , answers = A.initAnswers
    , progress = 0
    , end = -1
    }, Cmd.none )



---- UPDATE ----


type Msg
    = BranchChosen String
    | RadioChosen String
    | BoxChosen String
    | Next
    | Previous
    | Save
    | SaveAnswer String
    | AppendAnswer String
    | Submit


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        BranchChosen branch -> 
            case branch of 
                "Audience & Live Coding enthusiasts" ->
                    ( { model | branch = branch, questions = Q.initAudience, end = 12 }, Cmd.none )
                "Practitioners and Artists" ->
                    ( { model | branch = branch, questions = Q.initArtist, end = 12 }, Cmd.none )
                "Institutions" ->
                    ( { model | branch = branch, questions = Q.initInst, end = 12 }, Cmd.none )
                _ -> ( model, Cmd.none )

        RadioChosen choice ->
            let
                key = (String.fromInt model.progress) ++ "a"
                newQ = A.getSecondaryInput model.progress choice
            in
            ( { model | answers = A.insertAnswer model.progress choice model.answers
            , questions = Q.appendQuestion key newQ model.questions 
            }, Cmd.none )

        BoxChosen choice ->
            ( model, Cmd.none )

        Next -> 
            ( {model | progress = model.progress + 1 }, Cmd.none )

        Previous ->
            ( {model | progress = model.progress - 1}, Cmd.none )

        SaveAnswer answer -> 
            ( { model | answers = A.insertAnswer model.progress answer model.answers }, Cmd.none )

        AppendAnswer answer -> 
            let
                key = (String.fromInt model.progress) ++ "a"
            in
            ( { model | answers = A.appendAnswer key answer model.answers }, Cmd.none )

        Save -> 
            ( model, Cmd.none )

        Submit -> 
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.branch of 
        "" -> renderHome
        _ -> renderForm model



--- FUNCTIONS --- 

onClickChooser : (String -> Msg) -> Html.Attribute Msg 
onClickChooser msg =
    let
        decoder = D.map msg 
            ( D.at ["target", "innerText"] D.string )
    in
    on "click" decoder 


renderHome : Html Msg 
renderHome = 
    div [ HA.class "main" ]
            [
            h1 [] [ text "Live Coding Mapping Project" ]
            , br [] []
            , h2 [] [ text "Please choose your branch" ]
            , div [ HA.class "branches" ] [
                div [ HA.class "button", onClickChooser BranchChosen  ] [ text "Audience & Live Coding enthusiasts" ]
                , div [ HA.class "button", onClickChooser BranchChosen ] [ text "Practitioners and Artists" ]
                , div [ HA.class "button", onClickChooser BranchChosen ] [ text "Institutions" ]
                ]
            ]

renderForm : Model -> Html Msg 
renderForm model = 
    div [ HA.class "main" ]
            [
            if model.progress == 0 then 
                h1 [] [ text model.branch ]
            else 
                span [] []
            , if model.progress == 0 then 
                    div [ HA.class "intro flex-column" ] [
                    span [] [ text "Hey!" ]
                    , span [] [ text """CCU is taking part in an European wide on-the-fly project in collaboration with Hangar Barcelona, 
                        ZKM Karlsruhe and Ljudmilla Lubljana supported by EU’s Creative Europe program and the Creative Industry Fund NL.""" ]
                    , span [] [ text """Within this project, we want to facilitate a community knowledge base for live coders and those who are interested in live-coding.""" ]
                    , span [] [ text """In order to see and create links within the audience of live coding events, artists,  institutions and existing 
                        communities we want to know better where live coding takes place, what a live coder’s 
                        background can look like, how live coding enthusiasts currently share their interest and if and where they go to when visiting live coding events.""" ]
                    , span [] [ text """We know that this is probably not the first survey you’re receiving this month. That’s why we indicated an option to save and continue the fill-in at another time. 
                        Still, we ask you to make sure to send it back to us until the 17th of January.""" ]
                    , Html.b [] [ text """On another note: your information is treated confidential and will not be forwarded to any third parties or used for other purposes than this mapping.""" ]
                ]
              else 
                span [] []
            , br [] []
            , if model.progress == 0 then 
                div [ HA.class "button", onClick Next ] [ text "Continue" ]
             else 
                if model.progress < (model.end + 1) then 
                    div [ HA.class "interaction" ] [
                        h2 [ HA.class "question" ] [ text <| Q.getQuestion model.progress model.questions ]
                        , if String.isEmpty ( A.getSecondaryInput model.progress (A.getAnswer model.progress model.answers) ) then 
                            renderInput model
                        else 
                            renderSecondaryInput model
                    ]
                else 
                    span [] []
            , if model.progress > 0 && model.progress < (model.end + 1) then 
                div [ HA.class "buttons flex nav"] [
                    div [ HA.class "button", onClick Previous ] [ text "Previous" ]
                    , div [ HA.class "button", onClick Next ] [ text "Next" ]
                    , div [ HA.class "button", onClick Save ] [ text "Save" ]
                ]
             else 
                if model.progress > model.end then
                    div [ HA.class "buttons flex nav"] [
                        div [ HA.class "button end", onClick Submit ] [ h2 [] [ text "Submit" ] ]
                    ]
                else 
                    span [] []
            ]


renderInput : Model -> Html Msg 
renderInput model = 
    case A.typeInput model.progress of 
        "radio" ->
            let
                options = A.getOptions model.progress
            in            
            div [ HA.class "flex-column justify", onClickChooser RadioChosen ] <| (List.map (\x -> div [ HA.class "radios" ] [ text x ] ) options)
        "checkbox" -> 
            let
                options = A.getOptions model.progress
            in            
            div [ HA.class "flex-column justify", onClickChooser BoxChosen ] <| (List.map (\x -> div [ HA.class "checkbox" ] [ text x ] ) options)
        _ -> 
            L.lazy (\x -> input [ HA.class "answer"
                        , HA.id <| String.fromInt model.progress, onInput SaveAnswer
                        , HA.value x] []) ( A.getAnswer model.progress model.answers )


renderSecondaryInput : Model -> Html Msg 
renderSecondaryInput model = 
    let 
        key = (String.fromInt model.progress) ++ "a"
    in
    div [ HA.class "secondary" ] [ 
        div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers ]
        , h3 [] [ text <| Q.getQuestionS key model.questions ]
        , L.lazy (\x ->  
            input [ HA.class "secondary_answer"
                        , HA.id key, onInput AppendAnswer
                        , HA.value x] []) ( A.getAnswerS key model.answers )
    ]

---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
