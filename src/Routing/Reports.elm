module Routing.Reports exposing (goto, gotoNew)

import Array
import Model exposing (Model, Msg)
import Models.Good as Good
import Models.Header as Header
import Models.Record as Record
import Models.Report as Report
import Routing.Routes exposing (Route(NewReport, Reports))


goto : Model -> ( Model, Cmd msg )
goto model =
    let
        model_ =
            { model
                | route = Reports
                , header = Header.reportsList
            }
    in
        ( model_, Report.getReports model.storedData.reports )


gotoNew : Model -> ( Model, Cmd msg )
gotoNew model =
    let
        model_ =
            { model
                | route =
                    Record.initPotentialRecord
                        |> Array.repeat 1
                        |> NewReport
                , header = Header.newReport
            }
    in
        ( model_, Good.getGoods model.storedData.goods )
