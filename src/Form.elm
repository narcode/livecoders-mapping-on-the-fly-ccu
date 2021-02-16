module Form exposing (..)

import Json.Decode as D

type alias Model = 
    { formid : String
    , submitted : Bool
    , id : Int }


init : Model 
init = 
    { formid = "", submitted = False, id = 0 }

decode : D.Decoder Model
decode = 
    D.map3 Model 
        ( D.field "formid" D.string )
        ( D.field "submitted" D.bool )
        ( D.field "id" D.int )

updateId : Int -> Model -> Model 
updateId id model = 
    { model | id = id }

