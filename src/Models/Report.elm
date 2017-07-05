port module Models.Report
    exposing
        ( Report
        , Reports
        , getReport
        , getReports
        , reportsReceived
        )

import Date exposing (Date)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra as Decode
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


getReport : Uuid -> Cmd msg
getReport =
    Uuid.encode >> getReportPort


getReports : Reports -> Cmd msg
getReports =
    ModelUtil.commandIfEmpty getReportsPort


port reportsReceivedPort : (Value -> msg) -> Sub msg


port getReportPort : Value -> Cmd msg


port getReportsPort : () -> Cmd msg


fromValues : (Reports -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f


fromValue : Decoder Report
fromValue =
    Decode.decode Report
        |> Decode.required "id" Uuid.decoder
        |> Decode.required "createdAt" Decode.date
        |> Decode.required "updatedAt" Decode.date
        |> Decode.required "recordCount" Decode.int
