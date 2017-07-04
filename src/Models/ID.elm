module Models.ID exposing (ID, fromValue, fromValues, toValue)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Uuid exposing (Uuid)


type alias ID =
    { uuid : Uuid
    , name : String
    }


fromValue : Decoder ID
fromValue =
    Decode.decode ID
        |> Decode.required "id" Uuid.decoder
        |> Decode.required "name" Decode.string


fromValues : (List ID -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


toValue : ID -> Value
toValue { uuid, name } =
    Encode.object
        [ ( "id", Uuid.encode uuid )
        , ( "name", Encode.string name )
        ]
