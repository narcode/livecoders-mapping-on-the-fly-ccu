module Main exposing (..)

import Browser
import Html exposing (Html, text, div, h1, h2, h3, br, span , input)
import Html.Attributes as HA
import Html.Events exposing (onClick, onInput, on)
import Json.Decode as D
import Questions as Q
import Answers as A
import Html.Lazy as L
import String
import Http
import Form as F

---- MODEL ----


type alias Model =
    { branch: String 
    , formlink: F.Model
    , questions: Q.Model
    , answers: A.Model
    , progress: Int
    , end: Int
    }


init : ( Model, Cmd Msg )
init =
    ( { branch = ""
    , formlink = F.init
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
    | GotFormID (Result Http.Error F.Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        endpoint = "http://localhost:8080"
    in
    case msg of 
        BranchChosen branch -> 
            case branch of 
                "Audience & Live Coding enthusiasts" ->
                    ( { model | branch = branch, questions = Q.initAudience, end = 12 }, Cmd.none )
                "Practitioners and Artists" ->
                    ( { model | branch = branch, questions = Q.initArtist, end = 24 }, Cmd.none )
                "Institutions" ->
                    ( { model | branch = branch, questions = Q.initInst, end = 12 }, Cmd.none )
                _ -> ( model, Cmd.none )

        RadioChosen choice ->
            let
                key = (String.fromInt model.progress) ++ "a"
                newQ = A.getSecondaryInput model.progress choice model.branch
            in
            ( { model | answers = A.insertAnswer model.progress choice model.answers
            , questions = Q.appendQuestion key newQ model.questions 
            , progress = if String.isEmpty newQ then 
                    model.progress + 1
                else 
                    model.progress
            }, Cmd.none )

        BoxChosen choice ->
            ( { model | 
                answers = 
                    let
                        key = String.fromInt model.progress
                    in
                    if List.member choice (A.getcheckbox key model.answers) then
                        A.removeCheckbox model.progress choice model.answers 
                    else 
                        A.insertCheckbox model.progress choice model.answers 
            }, Cmd.none )

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

        GotFormID resp -> 
            case resp of 
                Ok res -> 
                    ( { model | formlink = res }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )

        Save -> 
            ( model
            , Http.post { url = endpoint ++ "/save"
                , body = Http.jsonBody (A.encodeAnswers model.branch model.answers)
                , expect = Http.expectJson GotFormID F.decode } 
            )

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
                    renderIntro model.branch
              else 
                span [] []
            , br [] []
            , if model.progress == 0 then 
                div [ HA.class "button", onClick Next ] [ text "Continue" ]
             else 
                if model.progress < (model.end + 1) then 
                    div [ HA.class "interaction" ] [
                        h2 [ HA.class "question" ] [ text <| Q.getQuestion model.progress model.questions ]
                        , if String.isEmpty ( A.getSecondaryInput model.progress (A.getAnswer model.progress model.answers) model.branch ) then 
                            case A.getAnswer model.progress model.answers of
                               "" -> renderInput model
                               _ -> 
                                if A.typeInput model.progress model.branch == "checkbox" then
                                    div [ HA.class "flex-column justify" ] [ 
                                        div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers ]
                                    ]
                                else 
                                    renderInput model
                        else 
                            Debug.log (( A.getSecondaryInput model.progress (A.getAnswer model.progress model.answers) model.branch ))
                            renderSecondaryInput model
                    ]
                else 
                    span [] []
            , if model.progress > 0 && model.progress < (model.end + 1) then 
                div [ HA.class "buttons flex nav" ] [
                    div [ HA.class "button", onClick Previous ] [ text "Previous" ]
                    , div [ HA.class "button", onClick Next ] [ text "Next" ]
                    , div [ HA.class "button", onClick Save ] [ text "Save" ]
                ]
             else 
                if model.progress > model.end then
                    div [ HA.class "buttons flex nav justify"] [
                        div [ HA.class "button", onClick Previous, HA.style "height" "22px" ] [ text "Previous" ]
                        , div [ HA.class "button end", onClick Submit ] [ h2 [] [ text "Submit" ] ]
                    ]
                else 
                    span [] []
            , if model.formlink.id > 0 then 
                div [ HA.class "formlink" ] [
                    div [] [ text "Personal link with saved progress: " ]
                    , Html.a [ HA.href <| makeLink model ] [ text <| makeLink model ] 
                 ]
              else 
                span [] []
            , if String.isEmpty (Q.getQuestionExtra model.progress model.branch) then
                span [] []
              else
                span [ HA.class "star" ] [ text <| Q.getQuestionExtra model.progress model.branch ]
            ]


renderInput : Model -> Html Msg 
renderInput model = 
    case A.typeInput model.progress model.branch of 
        "radio" ->
            let
                options = A.getOptions model.progress model.branch
            in 
            Debug.log (Debug.toString options)
            div [ HA.class "flex-column justify", onClickChooser RadioChosen ] <| (List.map (\x -> div [ HA.class "radios" ] [ text x ] ) options)
        "checkbox" -> 
            let
                options = A.getOptions model.progress model.branch
            in            
            div [ HA.class "flex-column justify"
                , onClickChooser BoxChosen
                ] <| (List.map (\x -> div [ HA.class "checkbox flex" ] [ div [ HA.class <| cssCheckbox model x ] [], text x ] ) options)
        _ ->       
            L.lazy (\x -> input [ HA.class "answer"
                        , HA.id <| String.fromInt model.progress, onInput SaveAnswer
                        , HA.value x] []) ( A.getAnswer model.progress model.answers )


cssCheckbox : Model -> String -> String 
cssCheckbox model val = 
    let
        key = String.fromInt model.progress
        list = A.getcheckbox key model.answers
    in
    if List.member val list then 
        "check"
    else 
        "uncheck"

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


renderIntro : String -> Html Msg 
renderIntro branch = 
    case branch of 
    "Audience & Live Coding enthusiasts" -> 
        div [ HA.class "intro flex-column" ] [
            span [] [ text "Hey!" ]
            , span [] [ text """CCU is taking part in an European wide on-the-fly project in collaboration with Hangar Barcelona, 
                ZKM Karlsruhe and Ljudmilla Lubljana supported by EU’s Creative Europe program and the Creative Industry Fund NL.""" ]
            , span [] [ text """Within this project, we want to facilitate a community knowledge base for live coders and those who are interested in live-coding.""" ]
            , span [] [ text """In order to see and create links within the audience of live coding events, artists,  institutions and existing 
                communities we want to know better where live coding takes place, what a live coder’s 
                background can look like, how live coding enthusiasts currently share their interest and if and where they go to when visiting live coding events.""" ]
            , span [] [ text """We know that this is probably not the first survey you’re receiving this month. That’s why we indicated an option to save and continue the fill-in at another time. 
                Still, we ask you to make sure to send it back to us within the next 3 weeks""" ]
            , Html.b [] [ text """On another note: your information is treated confidential and will not be forwarded to any third parties or used for other purposes than this mapping.""" ]
        ] 
    "Institutions" -> 
        div [ HA.class "intro flex-column" ] [
            span [] [ text "Hello dear reader," ]
            , span [] [ text """We are researchers responsible for the On-The-Fly Project, a research plan steered by the following four European cultural institutions and funded by the 
                Creative Europe Program by the European Commission and the Creative Industry Fund NL:
                Creative Coding Utrecht (digital creativity community) in Utrecht, the Netherlands;
                Hangar (center for arts production and research) based in Barcelona, Spain; 
                ZKM (center for art and media) based in Karlsruhe, Germany and 
                Ljudmila (art science laboratory) based in Ljubljana, Slovenia.""" ]
            , span [] [ text """The aim of this consortium for the On-The-Fly project is to explore the connections between live coders and those facilitating their talent throughout Europe. 
                By developing this knowledge, we aim at creating new possibilities for artists working with this performing technique as well as to establish 
                new connections among institutions supporting them. In our thoughts, this will help live coding artists in seeking for support to develop their
                 art further and in making the supporting institutions self-aware about the importance of their role in the widespread recognition of this performing art 
                 and to improve their action on the field.""" ]
            , span [] [ text """Therefore, this survey has the purpose of mapping out institutions and organizations that are currently providing facilities for the 
                flourishing live coding scene. Your help in doing this will be very appreciated. """ ]
            , span [] [ text """We know that this is probably not the first survey you’re receiving this month. That’s why we indicated an option to save and continue the fill-in at another time. 
                Still, we ask you to make sure to send it back to us within the next 3 weeks.""" ]
            , Html.b [] [ text """The information you will provide us, will be treated confidentially and will not be given to any third part for any purpose. 
                It will be employed only for the sake of the present research project and for no commercial reason. If you give us permission, 
                we may publish your name and some details of the activities hosted by your institution on a wiki page/project official page/other to represent the 
                state-of-the-art in the live coding world. Additionally, this will give more visibility to the artists who have interacted with you and hopefully create new and 
                wider connections in the live coding field. """ ]
        ]
    "Practitioners and Artists" -> 
        div [ HA.class "intro flex-column" ] [
            span [] [ text "Hey!" ]
            , span [] [ text """CCU is taking part in an European wide on-the-fly project in collaboration with Hangar Barcelona, 
                ZKM Karlsruhe and Ljudmilla Lubljana supported by EU’s Creative Europe program and the Creative Industry Fund NL.""" ]
            , span [] [ text """Within this project, we want to facilitate a community knowledge base for live coders.""" ]
            , span [] [ text """Above that, we strive to map out the existing community and professionalize the discipline of live coders within the practice.""" ]
            , span [] [ text """In order to see and create links with live coders, institutions and existing communities we want to know better where live coding takes place, 
                what a live coder’s background can look like, how live coders currently share their interest and if and where they perform their practice.""" ]
            , span [] [ text """This project is set up for the duration of the next two years.
                We’re happy to receive your feedback and elaborate together on how we can map out existing connections and establish new ones. 
                You can tick the box at the end, so we can send you updates on our progress whenever we move further.
                """]
            , span [] [ text """We know that this is probably not the first survey you’re receiving this month. That’s why we indicated an option to save and continue the fill-in at another time. 
                Still, we ask you to make sure to send it back to us within the next 3 weeks""" ]
            , Html.b [] [ text """On another note: your information is treated confidential and will not be forwarded to any third parties or used for other purposes than this mapping.""" ]
        ]
    _ -> span [] []
        
makeLink : Model -> String 
makeLink model = 
    "http://localhost:3000/?f=" ++ model.formlink.formid


---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
