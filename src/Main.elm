module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, h2, img, br, span , a, input)
import Html.Attributes as HA exposing (src)
import Html.Keyed as Keyed
import Html.Events exposing (onClick, onInput, on)
import Json.Decode as D
import Json.Encode as E
import Questions as Q
import Answers as A
import Html.Lazy as L

---- MODEL ----


type alias Model =
    { branch: String 
    , formlink: String
    , questions: Q.Model
    , answers: A.Model
    , progress: Int
    }


init : ( Model, Cmd Msg )
init =
    ( { branch = ""
    , formlink = ""
    , questions = Q.initAudience 
    , answers = A.initAnswers
    , progress = 0
    }, Cmd.none )



---- UPDATE ----


type Msg
    = BranchChosen String
    | Next
    | Previous
    | Save
    | SaveAnswer String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        BranchChosen branch -> 
            case branch of 
                "Audience & Live Coding enthusiasts" ->
                    ( { model | branch = branch, questions = Q.initAudience }, Cmd.none )
                "Practitioners and Artists" ->
                    ( { model | branch = branch, questions = Q.initArtist }, Cmd.none )
                "Institutions" ->
                    ( { model | branch = branch, questions = Q.initInst }, Cmd.none )
                _ -> ( model, Cmd.none )

        Next -> 
            ( {model | progress = model.progress + 1}, Cmd.none )

        Previous ->
            ( {model | progress = model.progress - 1}, Cmd.none )

        SaveAnswer answer -> 
            ( { model | answers = A.insertAnswer model.progress answer model.answers }, Cmd.none )

        Save -> 
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    case model.branch of 
        "" -> renderHome
        _ -> renderForm model



--- FUNCTIONS --- 

branchChooser : (String -> Msg) -> Html.Attribute Msg 
branchChooser msg =
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
                div [ HA.class "button", branchChooser BranchChosen  ] [ text "Audience & Live Coding enthusiasts" ]
                , div [ HA.class "button", branchChooser BranchChosen ] [ text "Practitioners and Artists" ]
                , div [ HA.class "button", branchChooser BranchChosen ] [ text "Institutions" ]
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
                div [ HA.class "interaction" ] [
                    h2 [ HA.class "question" ] [ text <| Q.getQuestion model.progress model.questions ]
                    , L.lazy (\x -> input [ HA.class "answer"
                        , HA.id <| String.fromInt model.progress, onInput SaveAnswer
                        , HA.value x] []) ( A.getAnswer model.progress model.answers )
                ]
            , if model.progress > 0 then 
                div [ HA.class "buttons flex"] [
                    div [ HA.class "button", onClick Previous ] [ text "Previous" ]
                    , div [ HA.class "button", onClick Next ] [ text "Next" ]
                    , div [ HA.class "button", onClick Save ] [ text "Save" ]
                ]
             else 
                span [] []
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
