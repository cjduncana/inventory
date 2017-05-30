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
    let
        toDecoder possibleUuid name =
            case Uuid.fromString possibleUuid of
                Nothing ->
                    Decode.fail "Not a valid UUID"

                Just uuid ->
                    Decode.succeed <|
                        ID uuid name
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "name" Decode.string
            |> Decode.resolve


fromValues : (List ID -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


toValue : ID -> Value
toValue { uuid, name } =
    Encode.object
        [ ( "id", Encode.string <| Uuid.toString uuid )
        , ( "name", Encode.string name )
        ]
