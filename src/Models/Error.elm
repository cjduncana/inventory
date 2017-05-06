port module Models.Error exposing (Error(..), errorRecieved)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode


type Error
    = UnknownError String
    | DuplicateError String


errorRecieved : (Error -> msg) -> Sub msg
errorRecieved =
    errorRecievedPort << fromValue


port errorRecievedPort : (Value -> msg) -> Sub msg


fromValue : (Error -> msg) -> Value -> msg
fromValue f value =
    Decode.decodeValue errorDecoder value
        |> Result.withDefault (UnknownError "Error decoding the Error")
        |> f


errorDecoder : Decoder Error
errorDecoder =
    let
        toDecoder details name =
            Decode.succeed <|
                if String.isEmpty name then
                    UnknownError details
                else
                    DuplicateError name
    in
        Decode.decode toDecoder
            |> Decode.required "details" Decode.string
            |> Decode.optional "name" Decode.string ""
            |> Decode.resolve
