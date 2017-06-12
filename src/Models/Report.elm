port module Models.Report
    exposing
        ( Report
        , Reports
        , getReports
        , reportsReceived
        )

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode exposing (Value)
import Models.Utilities as ModelUtil
import Uuid exposing (Uuid)


type alias Report =
    { id : Uuid
    , reportedOn : Date
    , updatedOn : Date
    , recordCount : Int
    }


type alias Reports =
    List Report


reportsReceived : (Reports -> msg) -> Sub msg
reportsReceived =
    reportsReceivedPort << fromValues


getReports : Reports -> Cmd msg
getReports =
    ModelUtil.commandIfEmpty getReportsPort


port reportsReceivedPort : (Value -> msg) -> Sub msg


port getReportsPort : () -> Cmd msg


fromValues : (Reports -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


fromValue : Decoder Report
fromValue =
    let
        toDecoder id reportedOn updatedOn recordCount =
            case
                ( Uuid.fromString id
                , Date.fromString reportedOn
                , Date.fromString updatedOn
                )
            of
                ( Just uuid, Ok reportedTime, Ok updatedTime ) ->
                    Decode.succeed <|
                        Report uuid reportedTime updatedTime recordCount

                ( _, _, _ ) ->
                    Decode.fail "Failed while decoding."
    in
        Decode.decode toDecoder
            |> Decode.required "id" Decode.string
            |> Decode.required "createdAt" Decode.string
            |> Decode.required "updatedAt" Decode.string
            |> Decode.required "recordCount" Decode.int
            |> Decode.resolve
