module Subscriptions exposing (subscriptions)

import Material
import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.Dialog as Dialog
import Models.Good as Good
import Models.Error as Error
import Models.Market as Market
import Models.Record as Record
import Models.Report as Report


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Model.Mdl model
        , Brand.brandsReceived Model.BrandsReceived
        , Good.goodsReceived Model.GoodsReceived
        , Market.marketsReceived Model.MarketsReceived
        , Record.reportReceived Model.ReportReceived
        , Report.reportsReceived Model.ReportsReceived
        , Error.errorReceived Model.ErrorReceived
        , Dialog.imageSaved <| Model.DialogMsg << Dialog.ImageSaved
        ]
