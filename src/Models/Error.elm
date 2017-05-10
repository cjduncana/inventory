port module Models.Error exposing (Error(..), errorReceived)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode


type Error
    = UnknownError String
    | DuplicateError String


errorReceived : (Error -> msg) -> Sub msg
errorReceived =
    errorReceivedPort << fromValue


port errorReceivedPort : (Value -> msg) -> Sub msg


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
