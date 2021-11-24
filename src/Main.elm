port module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser as P
import Url.Parser.Query as Query
import Html exposing (Html, text, div, h1, h2, h3, br, span , input, textarea, select, option)
import Html.Attributes as HA
import Html.Events exposing (onClick, onInput, on, targetValue)
import Json.Decode as D
import Json.Encode as E
import Questions as Q
import Answers as A
import Html.Lazy as L
import String
import Http
import Form as F
import List
import Html exposing (option)

---- MODEL ----


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , branch: String 
    , formlink: F.Model
    , questions: Q.Model
    , answers: A.Model
    , currentWords : Int
    , currentRows : Int
    , progress: Int
    , endpoint: String
    , end: Int
    }

type alias Document msg =
  { title : String
  , body : List (Html msg)
  }

type alias Flags =
    {
    endpoint : String
    }


-- PORTS -- 
port sendNum : String -> Cmd msg 

init : Flags -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { key = key 
    , url = url
    , branch = "Creative Coders"
    , formlink = F.init
    , questions = Q.initCCoders 
    , answers = A.initAnswers
    , currentWords = 0
    , currentRows = 1
    , progress = 0
    , endpoint = flags.endpoint
    , end = 9
    }, Http.post { url = flags.endpoint ++ "/load"
                , body = Http.jsonBody (encodeLoad "f" url )
                , expect = Http.expectJson GotForm A.decode }  
    )

encodeLoad : String -> Url.Url -> E.Value
encodeLoad key url = 
    case P.parse (P.query <| parseFormLink key) url of 
        Just parsed -> 
            case parsed of
                Just token ->
                    E.object [
                    ( "formid", E.string token )
                    ]
                Nothing -> E.object []
        Nothing -> 
            E.object []

parseFormLink : String -> Query.Parser (Maybe String)
parseFormLink str = Query.string str    

---- UPDATE ----


type Msg
    = BranchChosen String
    | RadioChosen String
    | BoxChosen String
    | RadioBack
    | Next
    | Previous
    | Save
    | SaveAnswer String
    | SaveTextAreaAnswer Int String
    | AppendAnswer String
    | Submit
    | GotFormID (Result Http.Error F.Model)
    | GotForm (Result Http.Error A.Response)
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        endpoint = model.endpoint
    in
    case msg of 
        BranchChosen branch -> 
            case branch of 
                "Audience & Live Coding enthusiasts" ->
                    ( { model | branch = branch, questions = Q.initAudience, end = 20 }, Cmd.none )
                "Practitioners and Artists" ->
                    ( { model | branch = branch, questions = Q.initArtist, end = 24 }, Cmd.none )
                "Creative Coders" ->
                    ( { model | branch = branch, questions = Q.initCCoders, end = 24 }, Cmd.none )
                "Institutions" ->
                    ( { model | branch = branch, questions = Q.initInst, end = 16 }, Cmd.none )
                _ -> ( model, Cmd.none )

        RadioChosen choice ->
            let
                newQ = A.getSecondaryInput model.progress choice model.branch
                key = 
                    case newQ of
                        "What will you consider yourself?" -> (String.fromInt (model.progress+1))
                        _ -> (String.fromInt model.progress) ++ "a" 
            in
            ( { model | answers = A.insertAnswer model.progress choice model.answers
            , questions = Q.appendQuestion key newQ model.questions 
            , progress = 
                    case newQ of
                        "What will you consider yourself?" -> model.progress+1
                        _ -> 
                            if String.isEmpty newQ then
                                model.progress+1
                            else
                                model.progress 

            , end = 
                    if choice == "yes" && model.progress == 9 then
                        13
                    else
                        9
            }, Cmd.none )

        BoxChosen choice ->
            let
                key = String.fromInt model.progress
                keySecondary = (String.fromInt model.progress) ++ "a"
                newQ = A.getSecondaryInput model.progress choice model.branch
            in
            ( { model | answers = 
                    if List.member choice (A.getcheckbox key model.answers) then
                        A.removeCheckbox model.progress choice model.answers 
                    else 
                        A.insertCheckbox model.progress choice model.answers 
                , questions = 
                    case choice of
                        "Other" ->
                            Q.appendQuestion keySecondary newQ model.questions
                        "yes" ->
                            Q.appendQuestion keySecondary newQ model.questions
                        _ -> 
                            model.questions
            }, Cmd.none )

        Next -> 
            let
                prog = model.progress + 1
                currentWords = 
                    if String.isEmpty ( A.getAnswer prog model.answers ) then 
                        0 
                    else 
                        List.length <| String.words ( A.getAnswer prog model.answers )
            in
            ( {model | progress = prog, currentWords = currentWords }
            , if A.typeInput prog model.branch == "textarea" then
                sendNum <| String.fromInt prog 
              else 
                Cmd.none
            )

        Previous ->
            let
                prog = model.progress - 1
                currentWords = 
                    if String.isEmpty ( A.getAnswer prog model.answers ) then 
                        0 
                    else 
                        List.length <| String.words ( A.getAnswer prog model.answers )
            in
            ( {model | progress = prog, currentWords = currentWords}
            , if A.typeInput prog model.branch == "textarea" then
                sendNum <| String.fromInt prog 
              else 
                Cmd.none
            )

        RadioBack -> 
            let
                key = (String.fromInt model.progress) ++ "a"
                removeone = A.removeAnswer (String.fromInt model.progress) model.answers
                updatedAnswer = A.removeAnswer key removeone
            in
            ( { model | answers =  updatedAnswer}, Cmd.none )

        SaveAnswer answer -> 
            let
                updatedAnswer = A.insertAnswer model.progress answer model.answers
            in
            ( { model | answers =  updatedAnswer}, Cmd.none )

        SaveTextAreaAnswer _ answer -> 
            let
                max = Q.maxWords model.progress model.branch 
                updatedAnswer = A.insertAnswer model.progress answer model.answers
                currentWords = 
                    if String.isEmpty ( A.getAnswer model.progress model.answers ) then 
                        0 
                    else 
                        List.length <| String.words ( A.getAnswer model.progress model.answers )
            in
            if currentWords < max then
                ( { model | answers =  updatedAnswer, currentWords = currentWords }, sendNum <| String.fromInt model.progress )
            else 
                ( model, Cmd.none )

        AppendAnswer answer -> 
            let
                key = (String.fromInt model.progress) ++ "a"
            in
            ( { model | answers = A.appendAnswer key answer model.answers }, Cmd.none )

        GotFormID resp -> 
            case resp of 
                Ok res ->
                    let
                        formlink = model.formlink
                        updatedForm = { formlink | submitted = res.submitted, formid = res.formid, id = res.id }
                    in
                     
                    ( { model | formlink = updatedForm }, Cmd.none )
                Err _ ->
                    ( model, Cmd.none )

        GotForm resp ->
            case resp of 
                Ok form -> 
                    ( { model | answers = form.answers
                    , formlink = {id = form.id, submitted = form.submitted, formid = getFormLink "f" model.url }
                    , branch = form.branch
                    , progress = 1
                    , questions = getQuestions form.branch
                    , end = getIntQuestions form.branch }, Cmd.none )

                Err _ -> ( model, Cmd.none )

        Save -> 
            let
                method = 
                    if String.isEmpty model.formlink.formid then 
                        "/save"
                    else
                        "/update"
            in
            ( model
            , Http.post { url = endpoint ++ method
                , body = Http.jsonBody (A.encodeAnswers model.branch model.formlink.id False model.answers)
                , expect = Http.expectJson GotFormID F.decode } 
            )
            

        Submit -> 
            let
                method = 
                    if String.isEmpty model.formlink.formid then 
                        "/save"
                    else
                        "/update"
            in
            ( model
            , Http.post { url = endpoint ++ method
                , body = Http.jsonBody (A.encodeAnswers model.branch model.formlink.id True model.answers)
                , expect = Http.expectJson GotFormID F.decode } 
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url -> ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href -> ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    { title = "on-the-fly mapping survey"
    , body = 
        if model.formlink.submitted then 
            [renderThankYou]    
        else
            case model.branch of 
                "" -> [renderHome]
                _ -> [renderForm model]
    }


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

renderThankYou : Html Msg 
renderThankYou = 
    div [ HA.class "main" ]
            [
            h2 [] [ text "Creative Coding Mapping Project" ]
            , br [] []
            , h1 [] [ text "Thank you for your contribution!" ]
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
            , if model.progress > 0 && model.formlink.id > 0 && not (String.isEmpty model.formlink.formid) then 
                div [ HA.class "formlink" ] [
                    div [] [ text "Personal link with saved progress: " ]
                    , Html.a [ HA.href <| makeLink model ] [ text <| makeLink model ] 
                 ]
              else 
                span [] []
            , if model.progress == 0 then 
                div [ HA.class "button", onClick Next ] [ text "Continue" ]
             else 
                if model.progress < (model.end + 1) then 
                    div [ HA.class "interaction"
                        , if model.formlink.id > 0 && not (String.isEmpty model.formlink.formid) then
                            HA.style "margin-top" "70px"
                          else 
                            HA.style "" "" ] [
                        h2 [ HA.class "question" ] [ text <| Q.getQuestion model.progress model.questions ]
                        , if String.isEmpty ( A.getSecondaryInput model.progress (A.getAnswer model.progress model.answers) model.branch ) then 
                            case A.getAnswer model.progress model.answers of
                               "" -> renderInput model
                               _ -> 
                                case A.typeInput model.progress model.branch of
                                    "checkbox" -> 
                                        div [ HA.class "flex-column justify" ] [ 
                                            div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers ]
                                        ]
                                    "radio" -> 
                                        div [ HA.class "flex-column justify" ] [ 
                                            div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers
                                                , div [ HA.class "radios back", onClick RadioBack ] [ text "change answer" ]
                                            ]
                                        ]
                                    "select" -> 
                                        div [ HA.class "flex-column justify" ] [ 
                                            div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers
                                                , div [ HA.class "radios back", onClick RadioBack ] [ text "change answer" ]
                                            ]
                                        ]
                                    "scale" -> 
                                        div [ HA.class "flex-column justify" ] [ 
                                            div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers
                                                , div [ HA.class "radios back", onClick RadioBack ] [ text "change answer" ]
                                            ]
                                        ]
                                    _ -> renderInput model
                        else 
                            renderSecondaryInput model
                    , if (Q.maxWords model.progress model.branch > 0) then 
                            span [ HA.class "maxwords" ] [ text <| String.fromInt model.currentWords ]
                          else
                            span [] []
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
                    div [ ] [
                        h1 [ ] [text "Thank you for answering, now you just need to submit"]
                        ,div [ HA.class "buttons flex nav justify"] [
                            div [ HA.class "button", onClick Previous, HA.style "height" "22px" ] [ text "Previous" ]
                            , div [ HA.class "button end", onClick Submit ] [ h2 [] [ text "Submit" ] ]
                        ]
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
            div [ HA.class "flex-column justify", onClickChooser RadioChosen ] <| (List.map (\x -> div [ HA.class "radios" ] [ text x ] ) options)
        "checkbox" -> 
            let
                options = A.getOptions model.progress model.branch
            in            
            div [ HA.class "flex-column justify"
                , onClickChooser BoxChosen
                ] <| (List.map (\x -> div [ HA.class "checkbox flex" ] [ div [ HA.class <| cssCheckbox model x ] [], text x ] ) options)
        "textarea" ->
            L.lazy (\x -> textarea [ HA.class "answer"
                        , HA.id <| String.fromInt model.progress, onInputCustom SaveTextAreaAnswer
                        , HA.rows 1
                        , HA.value x] []) ( A.getAnswer model.progress model.answers )
        "scale" ->
            let
                options = A.getOptions model.progress model.branch
            in 
            div [ HA.class "flex-scale justify", onClickChooser RadioChosen ] <| (List.map (\x -> div [ HA.class "radioscale" ] [ text x ] ) options)
        "select" -> 
            L.lazy (\_ -> select [ HA.class "answer"
                        , HA.id <| String.fromInt model.progress
                        , onInput SaveAnswer
                        ] <| List.map (\c -> option [ HA.value <| Tuple.second c ] [ text <| Tuple.second c] ) A.makeCountries ) ( A.getAnswer model.progress model.answers )
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
        div [ HA.class "radios" ] [ text <| A.getAnswer model.progress model.answers, div [ HA.class "radios back", onClick RadioBack ] [ text "change answer" ] ]
        , h3 [] [ text <| Q.getQuestionS key model.questions ]
        , L.lazy (\x ->  
            input [ HA.class "secondary_answer"
                        , HA.id key, onInput AppendAnswer
                        , HA.value x] []) ( A.getAnswerS key model.answers )
    ]


renderIntro : String -> Html Msg 
renderIntro branch = 
    case branch of 
    "Creative Coders" -> 
        div [ HA.class "intro flex-column" ] [
            span [] [ text "Hey!" ]
            , span [] [ text """CCU is taking part in an European wide on-the-fly project in collaboration with Hangar Barcelona, 
                ZKM Karlsruhe and Ljudmilla Lubljana supported by EU’s Creative Europe program and the Creative Industry Fund NL.""" ]
            , span [] [ text """Within this project, we strive to map out the existing community and professionalize the discipline of creative coders within the practice.""" ]
            , span [] [ text """By filling this survey you contribute to the database and can also add yourself to the database as a member of the creative coding community. If you want to stay anonymous you can use a nickname or just don't share your name, social media or website.""" ]
            , Html.b [] [ text """On another note: your information is treated confidential and will not be forwarded to any third parties or used for other purposes than this mapping.""" ]
        ]
    "Audience & Live Coding enthusiasts" -> 
        div [ HA.class "intro flex-column" ] [
            span [] [ text "Hey!" ]
            , span [] [ text """This survey is proposed by On-the-fly, a Creative Europe project that supports the development of the live coding practice, 
                    a sound and visual creation technique, generating a technological appropriation through the use and development of free and open softwares."""
                ]
            , span [] [ text """With this questionnaire we would like to find out more about the tastes and cultural habits of people assisting to livecoding performances 
                    and also about the experience of live coding performers. We would really appreciate if you can fill out the questionnaire which is 
                    anonymous and only takes about 5 minutes to complete.""" ]
            , span [] [ text """Thank you for your time!.""" ]
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
    "https://" ++ model.url.host ++ "/?f=" ++ model.formlink.formid


getIntQuestions : String -> Int 
getIntQuestions branch = 
    case branch of 
        "Practitioners and Artists" -> 24 
        "Institutions" -> 16
        _ -> 12

getQuestions : String -> Q.Model 
getQuestions branch = 
    case branch of 
        "Practitioners and Artists" -> Q.initArtist
        "Institutions" -> Q.initInst
        _ -> Q.initAudience

getFormLink : String -> Url.Url -> String
getFormLink key url = 
    case P.parse (P.query <| parseFormLink key) url of 
        Just parsed -> 
            case parsed of
                Just token ->
                    token
                Nothing -> ""
        Nothing -> 
            ""

onInputCustom : (Int -> String -> msg) -> Html.Attribute msg
onInputCustom tagger =
    on "input" (D.map2 tagger (D.at ["target", "scrollHeight"] D.int) targetValue)
    

---- PROGRAM ----


main : Program Flags Model Msg
main =
    Browser.application
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
