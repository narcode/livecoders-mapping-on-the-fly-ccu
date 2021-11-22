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
    , submitted : Bool
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


removeAnswer : String -> Model -> Model 
removeAnswer key model = 
    { model | answers = Dict.remove key model.answers }

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

encodeAnswers : String -> Int -> Bool -> Model -> E.Value
encodeAnswers branch formid submitted model =
    E.object [
        ( "branch", E.string branch )
        , ( "id", E.int formid )
        , ( "submitted", E.bool submitted )
        , ( "answers", parseAnswers model.answers )
        , ( "checkboxes", parseCheckboxes model.checkboxes )
    ]    

parseAnswers : Dict String String -> E.Value
parseAnswers dict = 
   E.object <| List.map (\(k,v) -> (k, E.string v) ) (Dict.toList dict)

parseCheckboxes : Dict String (List String) -> E.Value
parseCheckboxes dict =
    E.object <| List.map (\(k, v) -> (k, E.list E.string v) ) (Dict.toList dict)
    
makeString : List String -> String -> String
makeString list string = 
    if List.isEmpty list then 
        string 
    else 
        String.join "," list

typeInput : Int -> String -> String 
typeInput num branch =
    case branch of 
        "Creative Coders" -> 
            case num of 
                1 -> "select"
                2 -> "radio"
                3 -> "checkbox"
                4 -> "checkbox"
                5 -> "checkbox"
                6 -> "input"
                7 -> "input"
                8 -> "input"
                9 -> "radio"
                10 -> "checkbox"
                11 -> "input"
                12 -> "input"
                _ -> "input"

        "Practitioners and Artists" -> 
            case num of 
                4 -> "radio"
                5 -> "textarea"
                7 -> "textarea"
                8 -> "textarea"
                9 -> "textarea"
                10 -> "textarea"
                11 -> "textarea"
                12 -> "textarea"
                18 -> "textarea"
                19 -> "textarea"
                20 -> "textarea"
                21 -> "textarea"
                14 -> "radio"
                15 -> "radio"
                17 -> "radio"
                23 -> "radio"
                24 -> "checkbox" 
                _ -> "input"
        
        "Institutions" -> 
            case num of 
                5 -> "radio"
                6 -> "checkbox"
                8 -> "textarea"
                9 -> "radio"
                10 -> "textarea"
                11 -> "textarea"
                13 -> "radio"
                14 -> "radio"
                15 -> "radio"
                16 -> "checkbox" 
                _ -> "input"
        
        _ -> 
            case num of 
                2 -> "input"
                7 -> "scale"
                8 -> "scale"
                9 -> "scale"
                10 -> "scale"
                14 -> "textarea"
                16 -> "input"
                17 -> "input"
                _ -> "radio"


makeCountries : List (String, String)
makeCountries = 
    [
        ("NO","None")
        ,("AF","Afghanistan")
        ,("AX","Åland Islands")
        ,("AL","Albania")
        ,("DZ","Algeria")
        ,("AS","American Samoa")
        ,("AD","Andorra")
        ,("AO","Angola")
        ,("AI","Anguilla")
        ,("AQ","Antarctica")
        ,("AG","Antigua and Barbuda")
        ,("AR","Argentina")
        ,("AM","Armenia")
        ,("AW","Aruba")
        ,("AU","Australia")
        ,("AT","Austria")
        ,("AZ","Azerbaijan")
        ,("BS","Bahamas")
        ,("BH","Bahrain")
        ,("BD","Bangladesh")
        ,("BB","Barbados")
        ,("BY","Belarus")
        ,("BE","Belgium")
        ,("BZ","Belize")
        ,("BJ","Benin")
        ,("BM","Bermuda")
        ,("BT","Bhutan")
        ,("BO", "Bolivia, Plurinational State of")
        ,("BQ","Bonaire, Sint Eustatius and Saba")
        ,("BA","Bosnia and Herzegovina")
        ,("BW","Botswana")
        ,("BV","Bouvet Island")
        ,("BR","Brazil")
        ,("IO","British Indian Ocean Territory")
        ,("BN","Brunei Darussalam")
        ,("BG","Bulgaria")
        ,("BF","Burkina Faso")
        ,("BI","Burundi")
        ,("KH","Cambodia")
        ,("CM","Cameroon")
        ,("CA","Canada")
        ,("CV","Cape Verde")
        ,("KY","Cayman Islands")
        ,("CF","Central African Republic")
        ,("TD","Chad")
        ,("CL","Chile")
        ,("CN","China")
        ,("CX","Christmas Island")
        ,("CC","Cocos ,(Keeling) Islands")
        ,("CO","Colombia")
        ,("KM","Comoros")
        ,("CG","Congo")
        ,("CD","Congo, the Democratic Republic of the")
        ,("CK","Cook Islands")
        ,("CR","Costa Rica")
        ,("CI","Côte d'Ivoire")
        ,("HR","Croatia")
        ,("CU","Cuba")
        ,("CW","Curaçao")
        ,("CY","Cyprus")
        ,("CZ","Czech Republic")
        ,("DK","Denmark")
        ,("DJ","Djibouti")
        ,("DM","Dominica")
        ,("DO","Dominican Republic")
        ,("EC","Ecuador")
        ,("EG","Egypt")
        ,("SV","El Salvador")
        ,("GQ","Equatorial Guinea")
        ,("ER","Eritrea")
        ,("EE","Estonia")
        ,("ET","Ethiopia")
        ,("FK","Falkland Islands ,(Malvinas)")
        ,("FO","Faroe Islands")
        ,("FJ","Fiji")
        ,("FI","Finland")
        ,("FR","France")
        ,("GF","French Guiana")
        ,("PF","French Polynesia")
        ,("TF","French Southern Territories")
        ,("GA","Gabon")
        ,("GM","Gambia")
        ,("GE","Georgia")
        ,("DE","Germany")
        ,("GH","Ghana")
        ,("GI","Gibraltar")
        ,("GR","Greece")
        ,("GL","Greenland")
        ,("GD","Grenada")
        ,("GP","Guadeloupe")
        ,("GU","Guam")
        ,("GT","Guatemala")
        ,("GG","Guernsey")
        ,("GN","Guinea")
        ,("GW","Guinea-Bissau")
        ,("GY","Guyana")
        ,("HT","Haiti")
        ,("HM","Heard Island and McDonald Islands")
        ,("VA","Holy See ,(Vatican City State)")
        ,("HN","Honduras")
        ,("HK","Hong Kong")
        ,("HU","Hungary")
        ,("IS","Iceland")
        ,("IN","India")
        ,("ID","Indonesia")
        ,("IR","Iran, Islamic Republic of")
        ,("IQ","Iraq")
        ,("IE","Ireland")
        ,("IM","Isle of Man")
        ,("IL","Israel")
        ,("IT","Italy")
        ,("JM","Jamaica")
        ,("JP","Japan")
        ,("JE","Jersey")
        ,("JO","Jordan")
        ,("KZ","Kazakhstan")
        ,("KE","Kenya")
        ,("KI","Kiribati")
        ,("KP","Korea, Democratic People's Republic of")
        ,("KR","Korea, Republic of")
        ,("KW","Kuwait")
        ,("KG","Kyrgyzstan")
        ,("LA","Lao People's Democratic Republic")
        ,("LV","Latvia")
        ,("LB","Lebanon")
        ,("LS","Lesotho")
        ,("LR","Liberia")
        ,("LY","Libya")
        ,("LI","Liechtenstein")
        ,("LT","Lithuania")
        ,("LU","Luxembourg")
        ,("MO","Macao")
        ,("MK","Macedonia, the former Yugoslav Republic of")
        ,("MG","Madagascar")
        ,("MW","Malawi")
        ,("MY","Malaysia")
        ,("MV","Maldives")
        ,("ML","Mali")
        ,("MT","Malta")
        ,("MH","Marshall Islands")
        ,("MQ","Martinique")
        ,("MR","Mauritania")
        ,("MU","Mauritius")
        ,("YT","Mayotte")
        ,("MX","Mexico")
        ,("FM","Micronesia, Federated States of")
        ,("MD","Moldova, Republic of")
        ,("MC","Monaco")
        ,("MN","Mongolia")
        ,("ME","Montenegro")
        ,("MS","Montserrat")
        ,("MA","Morocco")
        ,("MZ","Mozambique")
        ,("MM","Myanmar")
        ,("NA","Namibia")
        ,("NR","Nauru")
        ,("NP","Nepal")
        ,("NL","Netherlands")
        ,("NC","New Caledonia")
        ,("NZ","New Zealand")
        ,("NI","Nicaragua")
        ,("NE","Niger")
        ,("NG","Nigeria")
        ,("NU","Niue")
        ,("NF","Norfolk Island")
        ,("MP","Northern Mariana Islands")
        ,("NO","Norway")
        ,("OM","Oman")
        ,("PK","Pakistan")
        ,("PW","Palau")
        ,("PS","Palestinian Territory, Occupied")
        ,("PA","Panama")
        ,("PG","Papua New Guinea")
        ,("PY","Paraguay")
        ,("PE","Peru")
        ,("PH","Philippines")
        ,("PN","Pitcairn")
        ,("PL","Poland")
        ,("PT","Portugal")
        ,("PR","Puerto Rico")
        ,("QA","Qatar")
        ,("RE","Réunion")
        ,("RO","Romania")
        ,("RU","Russian Federation")
        ,("RW","Rwanda")
        ,("BL","Saint Barthélemy")
        ,("SH","Saint Helena, Ascension and Tristan da Cunha")
        ,("KN","Saint Kitts and Nevis")
        ,("LC","Saint Lucia")
        ,("MF","Saint Martin ,(French part)")
        ,("PM","Saint Pierre and Miquelon")
        ,("VC","Saint Vincent and the Grenadines")
        ,("WS","Samoa")
        ,("SM","San Marino")
        ,("ST","Sao Tome and Principe")
        ,("SA","Saudi Arabia")
        ,("SN","Senegal")
        ,("RS","Serbia")
        ,("SC","Seychelles")
        ,("SL","Sierra Leone")
        ,("SG","Singapore")
        ,("SX","Sint Maarten ,(Dutch part)")
        ,("SK","Slovakia")
        ,("SI","Slovenia")
        ,("SB","Solomon Islands")
        ,("SO","Somalia")
        ,("ZA","South Africa")
        ,("GS","South Georgia and the South Sandwich Islands")
        ,("SS","South Sudan")
        ,("ES","Spain")
        ,("LK","Sri Lanka")
        ,("SD","Sudan")
        ,("SR","Suriname")
        ,("SJ","Svalbard and Jan Mayen")
        ,("SZ","Swaziland")
        ,("SE","Sweden")
        ,("CH","Switzerland")
        ,("SY","Syrian Arab Republic")
        ,("TW","Taiwan")
        ,("TJ","Tajikistan")
        ,("TZ","Tanzania, United Republic of")
        ,("TH","Thailand")
        ,("TL","Timor-Leste")
        ,("TG","Togo")
        ,("TK","Tokelau")
        ,("TO","Tonga")
        ,("TT","Trinidad and Tobago")
        ,("TN","Tunisia")
        ,("TR","Turkey")
        ,("TM","Turkmenistan")
        ,("TC","Turks and Caicos Islands")
        ,("TV","Tuvalu")
        ,("UG","Uganda")
        ,("UA","Ukraine")
        ,("AE","United Arab Emirates")
        ,("GB","United Kingdom")
        ,("US","United States")
        ,("UM","United States Minor Outlying Islands")
        ,("UY","Uruguay")
        ,("UZ","Uzbekistan")
        ,("VU","Vanuatu")
        ,("VE","Venezuela, Bolivarian Republic of")
        ,("VN","Viet Nam")
        ,("VG","Virgin Islands, British")
        ,("VI","Virgin Islands, U.S.")
        ,("WF","Wallis and Futuna")
        ,("EH","Western Sahara")
        ,("YE","Yemen")
        ,("ZM","Zambia")
        ,("ZW","Zimbabwe")
    ]

getOptions : Int -> String -> List String
getOptions num branch = 
    case branch of 
        "Creative Coders" -> 
            case num of 
                2 -> [ "She/Her"
                    , "He/Him"
                    , "Ze/Zir"
                    , "Xe/Xim"
                    , "Sie/Hir"
                    , "They/Them"
                    ]
                3 -> [ "Design"
                    , "Art"
                    , "Research"
                    , "Education"
                    , "Music"
                    , "Performance"
                    , "Science"
                    , "Live Coding"
                    , "Digital Culture"
                    ]
                4 -> [ "Machine Learning & AI"
                    , "Hardware"
                    , "Data Visualization"
                    , "3D"
                    , "AR"
                    , "Web/Online"
                    , "Print"
                    , "Theater"
                    , "Dance"
                    , "Curator"
                    , "Storytelling/Narrative"
                    , "Bio Hacking"
                    , "Hacking"
                    , "Visual Communication"
                    , "Product"
                    , "Experience"
                    , "Sculpture"
                    , "Mixed Media"
                    , "Scenography"
                    , "Film"
                    , "Interactive and Informative"
                    , "Audiovisual"
                    , "Social"
                    , "Participatory"
                    , "Games"
                    , "Speculative"
                    , "Critical"
                    , "Composition"
                    , "Instruments"
                    , "Algorithmic / Generative"
                    , "Tinkering"
                    , "Digital Fabrication"
                    , "Art Science"
                    , "Frontend"
                    , "Backend"
                    ]
                5 -> 
                    [ "Phyton"
                    ,"javascript"
                    ,"C++"
                    ,"Browser"
                    ,"p5js"
                    , "Processing"
                    , "openFrameworks"
                    , "Arduino"
                    , "Hydra"
                    , "OPENRNDR"
                    , "Pure Data"
                    , "Max/MSP/Jitter"
                    , "three.js"
                    , "Unity"
                    , "vvvv"
                    , "Touchdesigner"
                    , "Unreal"
                    , "Grasshopper"
                    , "WebGL"
                    , "Clojure"
                    , "DrawBot"
                    , "Paper.js"
                    , "D3.js"
                    , "Cables.gl"
                    , "Mercury Playground"
                    , "Codeklavier"
                    , "RunwayML"
                    , "Basiljs"
                    , "Thi.ng"
                    , "Cinder"
                    , "Supercollider"
                    , "Juce"
                    , "NAP"
                    ]
                6 -> ["yes", "no"]
                7 -> ["yes", "no"]
                8 -> ["yes", "no"]
                9 -> [ "yes", "no" ]
                10 -> [ "Maker"
                     ,"Contributor"
                     ,"Enthusiast"
                     ]
                11 -> ["yes", "no"]
                12 -> ["yes", "no"]
                _ -> ["yes", "no"]

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

        "Institutions" -> 
            case num of 
                5 -> 
                    [ "Private"
                    , "Public"
                    , "Mixed"
                    ]
                6 -> 
                    [ "Fine Art"
                    , "Media Art"
                    , "Creative Technology"
                    , "Performing Arts"
                    , "Design"
                    , "Music Technology and Sound Design"
                    , "Game Industry"
                    , "Festival / Event Organizer / Venue"
                    , "Research & Education"
                    , "Other"
                    ]
                14 -> 
                    [ "Residencies"
                    , "Presentation/Performance space" 
                    , "Subsidy"
                    , "Research collaborations"
                    , "Other"
                    ]
                16 -> 
                    [ "Receive news about the On-The-Fly Project"
                    , "Receive the CCU newsletter"
                    , "Connect with forum.toplap.org"
                    ]
                _ -> [ "yes", "no" ]

        _ ->     
            case num of 
                1 -> [ "Algorave"
                    , "Workshop"
                    , "Hackathon"
                    , "Talk"
                    , "I don't know"
                    , "Other"
                    ]
                3 -> [ "I found out by myself"
                    , "Friend"
                    , "Live coding performer"
                    , "Family"
                    , "Colleague (of work)"
                    , "Colleague (of centre of studies)"
                    , "Other"
                    ]
                4 -> [ "Conventional Social Media (FB, Instagram, TW, etc.)"
                    , "Alternative/Open Social Media (Mastodon, etc.)"
                    , "Conventional Media"
                    , "Media from the place where the event takes place"
                    , "Word of mouth"
                    , "Other"
                    ]
                5 -> [ "Since some days/weeks ago"
                    , "Since 6 months ago"
                    , "Since 1 year ago"
                    , "Since 2 years ago"
                    , "Since 2 to 5 years ago"
                    , "Since more than 5 years ago"
                    ]
                6 -> [ "1"
                    , "2"
                    , "3"
                    , "4"
                    , "5"
                    , "More than 5"
                    ]
                7 -> [ "0. It has dereased a lot"
                    , "1"
                    , "2"
                    , "3"
                    , "4"
                    , "5. Equal as before"
                    , "6"
                    , "7"
                    , "8"
                    , "9"
                    , "10. It has increaseda lot"
                    ]
                8 -> [ "0. Very improbable"
                    , "1"
                    , "2"
                    , "3"
                    , "4"
                    , "5"
                    , "6"
                    , "7"
                    , "8"
                    , "9"
                    , "10. Very probable"
                    ]
                9 -> [ "0. Very dissatisfied"
                    , "1"
                    , "2"
                    , "3"
                    , "4"
                    , "5"
                    , "6"
                    , "7"
                    , "8"
                    , "9"
                    , "10. Very satisfied"
                    ]
                10 -> [ "0. Not interested"
                    , "1"
                    , "2"
                    , "3"
                    , "4"
                    , "5"
                    , "6"
                    , "7"
                    , "8"
                    , "9"
                    , "10. Very interested"
                    ]
                11 -> 
                    [ "Electronic Dance Music"
                    , "Experimental Noise"
                    , "Jazz/Classic"
                    , "Pop/Rock/Metal"
                    , "I don't identify myself with this genres"
                    ]
                13 -> 
                    [ "No, and I have no intention of doing it"
                    , "No, but I may give it a try in the future"
                    , "Yes, and I'm starting to practice it by myself"
                    , "Yes, I consider myself a Livecoder"
                    ]
                15 -> 
                    [ "Male"
                    , "Female"
                    , "Non-binary"
                    ]
                18 -> 
                    [ "Primary school"
                    , "High school"
                    , "College/bachelor degree"
                    , "Master/postgraduate degree"
                    , "PhD"
                    , "Other"
                    , "I don't know"
                    ]
                19 -> 
                    [ "Arts and Humanities"
                    , "Sciences"
                    , "Health Sciences"
                    , "Social and Legal Sciences"
                    , "Engineering and architecture"
                    , "None of this"
                    ]
                20 -> 
                    [ "Arts and Humanities"
                    , "Sciences"
                    , "Health Sciences"
                    , "Social and Legal Sciences"
                    , "Engineering and architecture"
                    , "I'm studying"
                    , "I'm not working at the moment"
                    , "Other"
                    ]
                _ -> [ "yes", "no" ]

getSecondaryInput : Int -> String -> String -> String 
getSecondaryInput num option branch =
    case branch of 
        "Creative Coders" -> 
            case num of
                9 -> case option of
                        "yes" -> "What will you consider yourself?"
                        _ -> ""
                3 -> 
                    case option of
                        "Other" -> "Other" 
                        _ -> ""
                _ -> ""
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
                        "yes" -> "Please name venues, events or festivals where they took place"
                        "no" -> "Would you like to do so? If so, what kind of venues would you imagine yourself to perform in?"
                        _ -> ""
                23 -> 
                    case option of 
                        "yes" -> "Please share your e-mail address with us, so we can get in contact with you"
                        _ -> ""                        
                _ -> ""


        "Institutions" ->
            case num of 
                6 -> 
                    case option of
                    "Other" -> "Please describe"
                    _ -> ""
                13 -> 
                    case option of 
                        "yes" -> "What kind of facilities can your organisation offer for live coding experiences?"
                        "no" -> "Why not?" 
                        _ -> ""
                14 ->
                    case option of 
                        "Presentation/Performance space" -> "What kind of facilities can your organisation offer for live coding experiences ?"
                        "Other" -> "Please describe"
                        _ -> ""
                15 -> 
                    case option of 
                        "yes" -> "Please share your e-mail address with us, so we can get in contact with you"
                        _ -> ""      
                _ -> ""

        _ -> 
            case num of
                1 -> 
                    case option of
                    "Other" -> "Please describe"
                    _ -> ""
                3 -> 
                    case option of
                    "Other" -> "Please describe"
                    _ -> ""
                4 -> 
                    case option of
                    "Other" -> "Please describe"
                    _ -> ""
                20 -> 
                    case option of
                    "Other" -> "Please describe"
                    _ -> ""
                _ -> ""

decode : D.Decoder Response
decode = 
    D.map4 Response 
        ( D.field "id" D.int )
        ( D.field "branch" D.string )
        ( D.field "submitted" D.bool )
        ( D.field "answers" decodeAnswers )

decodeAnswers : D.Decoder Model 
decodeAnswers = 
    D.map2 Model 
        ( D.field "answers" (D.dict D.string) )
        ( D.field "checkboxes" (D.dict <| D.list D.string) )
