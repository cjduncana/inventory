port module Models.Record
    exposing
        ( FormMsg
            ( DeleteRecord
            , GoodDropdownMsg
            , GoodUpdate
            , QuantityStoredUpdate
            , QuantityUsed
            )
        , Msg(FormUpdate, Mdl, SaveForm, ViewReport)
        , PotentialRecord
        , PotentialRecords
        , Record
        , Records
        , addRecordIfComplete
        , addNewRecord
        , checkRecord
        , createReport
        , initPotentialRecord
        , reportReceived
        , sanitizeRecords
        , setGood
        , setQuantityStored
        , setQuantityUsed
        )

import Array exposing (Array)
import Array.Extra as Array
import Dropdown exposing (State)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode exposing (Value)
import Material
import Maybe.Extra as Maybe
import Models.Good as Good exposing (Good)
import Result.Extra as Result
import Uuid exposing (Uuid)


type alias RecordData =
    { good : Good
    , quantityStored : Int
    , quantityUsed : Int
    }


type alias Record =
    { id : Uuid
    , good : Good
    , quantityStored : Int
    , quantityUsed : Int
    }


type alias Records =
    List Record


type alias PotentialRecord =
    { good : Maybe Good
    , quantityStored : Result String Int
    , quantityUsed : Result String Int
    }


type alias PotentialRecords =
    Array ( State, PotentialRecord )


addNewRecord : PotentialRecords -> PotentialRecords
addNewRecord =
    Array.push initPotentialRecord


checkRecord : PotentialRecord -> Bool
checkRecord record =
    Maybe.isJust record.good
        && Result.isOk record.quantityStored
        && Result.isOk record.quantityUsed


isRecordDirty : PotentialRecord -> Bool
isRecordDirty record =
    Maybe.isJust record.good
        || Result.isOk record.quantityStored
        || Result.isOk record.quantityUsed


sanitizeRecord : PotentialRecord -> Maybe RecordData
sanitizeRecord record =
    Just RecordData
        |> Maybe.andMap record.good
        |> Maybe.andMap (Result.toMaybe record.quantityStored)
        |> Maybe.andMap (Result.toMaybe record.quantityUsed)


sanitizeRecords : Array PotentialRecord -> Maybe (List RecordData)
sanitizeRecords =
    Just
        >> Maybe.filter
            ((\rs ->
                (Array.length rs
                    - 1
                    |> flip Array.get rs
                    |> Maybe.map isRecordDirty
                    |> Maybe.withDefault True
                )
                    || Array.length rs
                    == 1
             )
                >> not
            )
        >> Maybe.map
            (Array.sliceUntil -1
                >> Array.map sanitizeRecord
                >> Array.toList
                >> Maybe.combine
            )
        >> Maybe.join


addRecordIfComplete : PotentialRecords -> PotentialRecords
addRecordIfComplete records =
    Array.length records
        - 1
        |> flip Array.get records
        |> Maybe.map
            (Tuple.second
                >> Just
                >> Maybe.filter checkRecord
                >> Maybe.map (always <| addNewRecord records)
                >> Maybe.withDefault records
            )
        |> Maybe.withDefault (addNewRecord records)


initPotentialRecord : ( State, PotentialRecord )
initPotentialRecord =
    ( Dropdown.newState "good", PotentialRecord Nothing (Err "") (Err "") )


setGood : Maybe Good -> PotentialRecord -> PotentialRecord
setGood good record =
    PotentialRecord good record.quantityStored record.quantityUsed


setQuantityStored : Result String Int -> PotentialRecord -> PotentialRecord
setQuantityStored quantity record =
    PotentialRecord record.good quantity record.quantityUsed


setQuantityUsed : Result String Int -> PotentialRecord -> PotentialRecord
setQuantityUsed quantity record =
    PotentialRecord record.good record.quantityStored quantity


type Msg
    = FormUpdate FormMsg
    | SaveForm (List RecordData)
    | ViewReport Uuid
    | Mdl (Material.Msg Msg)


type FormMsg
    = DeleteRecord Int
    | GoodDropdownMsg Int (Dropdown.Msg Good)
    | GoodUpdate Int (Maybe Good)
    | QuantityStoredUpdate Int String
    | QuantityUsed Int String


createReport : List RecordData -> Cmd msg
createReport data =
    toCreateValue data
        |> createReportPort


reportReceived : (Records -> msg) -> Sub msg
reportReceived =
    reportReceivedPort << fromValues


port createReportPort : Value -> Cmd msg


port reportReceivedPort : (Value -> msg) -> Sub msg


toCreateValue : List RecordData -> Value
toCreateValue =
    List.map
        (\data ->
            [ ( "goodId"
              , Good.getUuid data.good |> Uuid.encode
              )
            , ( "quantityStored"
              , Encode.int data.quantityStored
              )
            , ( "quantityUsed"
              , Encode.int data.quantityUsed
              )
            ]
                |> Encode.object
        )
        >> Encode.list


fromValue : Decoder Record
fromValue =
    Decode.decode Record
        |> Decode.required "id" Uuid.decoder
        |> Decode.required "good" Good.fromValue
        |> Decode.required "quantityStored" Decode.int
        |> Decode.required "quantityUsed" Decode.int


fromValues : (Records -> msg) -> Value -> msg
fromValues f value =
    Decode.decodeValue (Decode.list fromValue) value
        |> Result.withDefault []
        |> f
