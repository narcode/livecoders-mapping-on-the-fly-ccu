module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, h2, img, br, span , a)
import Html.Attributes as HA exposing (src)
import Html.Keyed as Keyed
import Html.Events exposing (onClick, onInput, on)
import Json.Decode as D
import Json.Encode as E
import Questions as Q
import Questions exposing (initAudience)

---- MODEL ----


type alias Model =
    { branch: String 
    , formlink: String
    , questions: Q.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { branch = ""
    , formlink = ""
    , questions = Q.initAudience 
    }, Cmd.none )



---- UPDATE ----


type Msg
    = BranchChosen String


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
            h1 [] [ text model.branch ]
            , br [] []
            , h2 [] [ text model.questions.questions.one ]
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
