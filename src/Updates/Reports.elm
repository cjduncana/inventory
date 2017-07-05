module Updates.Reports exposing (update, updateReport, updateReports)

import Array
import Array.Extra as Array
import Dropdown
import Material
import Model exposing (Model)
import Models.Dropdown as Dropdown
import Models.Record as Record
    exposing
        ( FormMsg
        , Msg
        , PotentialRecords
        , Records
        )
import Models.Report exposing (Reports)
import Routing.Reports as Reports
import Routing.Routes as Routes
import Updates.Utilities as UpdateUtils


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.route ) of
        ( Record.FormUpdate formMsg, Routes.NewReport records ) ->
            let
                ( route_, command_ ) =
                    formUpdate formMsg records
                        |> Tuple.mapFirst
                            (Record.addRecordIfComplete
                                >> Routes.NewReport
                            )

                model_ =
                    { model | route = route_ }
            in
                ( model_, command_ )

        ( Record.FormUpdate _, _ ) ->
            ( model, Cmd.none )

        ( Record.SaveForm records, _ ) ->
            let
                ( model_, command ) =
                    Reports.goto model
            in
                model_ ! [ Record.createReport records, command ]

        ( Record.ViewReport uuid, _ ) ->
            Reports.gotoReport uuid model

        ( Record.Mdl msg_, _ ) ->
            Material.update Record.Mdl msg_ model


formUpdate : FormMsg -> PotentialRecords -> ( PotentialRecords, Cmd Msg )
formUpdate formMsg records =
    case formMsg of
        Record.DeleteRecord index ->
            let
                records_ =
                    Array.removeAt index records
            in
                ( records_, Cmd.none )

        Record.GoodDropdownMsg index msg_ ->
            let
                state =
                    Array.get index records
                        |> Maybe.map Tuple.first
                        |> Maybe.withDefault (Dropdown.newState "good")

                ( state_, command_ ) =
                    Dropdown.update (Dropdown.goodConfig index) msg_ state

                records_ =
                    records
                        |> Array.update index (Tuple.mapFirst (always state_))
            in
                ( records_, Cmd.map Record.FormUpdate command_ )

        Record.GoodUpdate index good ->
            let
                updateRecord =
                    Tuple.mapSecond (Record.setGood good)

                records_ =
                    Array.update index updateRecord records
            in
                ( records_, Cmd.none )

        Record.QuantityStoredUpdate index quantity ->
            let
                updateRecord =
                    Tuple.mapSecond
                        (Record.setQuantityStored (parseQuantity quantity))

                records_ =
                    Array.update index updateRecord records
            in
                ( records_, Cmd.none )

        Record.QuantityUsed index quantity ->
            let
                updateRecord =
                    Tuple.mapSecond
                        (Record.setQuantityUsed (parseQuantity quantity))

                records_ =
                    Array.update index updateRecord records
            in
                ( records_, Cmd.none )


updateReport : Records -> Model -> ( Model, Cmd msg )
updateReport records model =
    ( model.route, Cmd.none )
        |> Tuple.mapFirst
            (\route ->
                case route of
                    Routes.ViewReport _ ->
                        { model
                            | route = Routes.ViewReport (Just records)
                        }

                    _ ->
                        model
            )


updateReports : Reports -> Model -> ( Model, Cmd msg )
updateReports reports model =
    model.storedData
        |> (\data -> { data | reports = reports })
        |> UpdateUtils.updateStoredData model


parseQuantity : String -> Result String Int
parseQuantity quantity =
    let
        validate number =
            if number >= 0 then
                Ok number
            else
                Err quantity
    in
        String.toInt quantity
            |> Result.andThen validate
            |> Result.mapError (always quantity)
