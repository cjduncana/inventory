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
    Report.getReports model.storedData.reports
        |> (,)
            { model
                | route = Reports
                , header = Header.reportsList
            }


gotoNew : Model -> ( Model, Cmd msg )
gotoNew model =
    Good.getGoods model.storedData.goods
        |> (,)
            { model
                | route =
                    Record.initPotentialRecord
                        |> Array.repeat 1
                        |> NewReport
                , header = Header.newReport
            }
