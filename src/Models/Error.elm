port module Models.Error
    exposing
        ( Error(UnknownError, DuplicateError)
        , errorReceived
        )

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
        toDecoder errorType details =
            Decode.succeed <|
                case errorType of
                    "duplicate_error" ->
                        DuplicateError details

                    _ ->
                        UnknownError details
    in
        Decode.decode toDecoder
            |> Decode.optional "errorType" Decode.string ""
            |> Decode.required "details" Decode.string
            |> Decode.resolve
