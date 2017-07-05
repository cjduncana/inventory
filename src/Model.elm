module Model
    exposing
        ( Model
        , Msg
            ( AddEditReport
            , BrandsReceived
            , DeleteBrand
            , DeleteGood
            , DeleteMarket
            , DialogMsg
            , ErrorReceived
            , GoodsReceived
            , MarketsReceived
            , Mdl
            , NavigateTo
            , ReportReceived
            , ReportsReceived
            , SnackbarMsg
            )
        , StoredData
        , init
        )

import Material
import Models.Brand exposing (Brand, Brands)
import Models.Dialog as Dialog exposing (DialogView(Default))
import Models.Error exposing (Error)
import Models.Good exposing (Good, Goods)
import Models.Header as Header exposing (Header)
import Models.Snackbar as Snackbar
import Models.Market exposing (Market, Markets)
import Models.Record as Record exposing (Records)
import Models.Report exposing (Reports)
import Routing.Routes exposing (Route(Home))


type alias Model =
    { mdl : Material.Model
    , route : Route
    , storedData : StoredData
    , header : Header
    , dialogView : DialogView
    , snackbar : Snackbar.Model
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    , route = Home
    , storedData = initStoredData
    , header = Header.init
    , dialogView = Default
    , snackbar = Snackbar.init
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Material.init Mdl )


type alias StoredData =
    { brands : Brands
    , goods : Goods
    , markets : Markets
    , reports : Reports
    }


initStoredData : StoredData
initStoredData =
    StoredData [] [] [] []


type Msg
    = Mdl (Material.Msg Msg)
    | SnackbarMsg Snackbar.Msg
    | NavigateTo Route
    | ErrorReceived Error
    | DialogMsg Dialog.Msg
    | BrandsReceived Brands
    | GoodsReceived Goods
    | MarketsReceived Markets
    | ReportReceived Records
    | ReportsReceived Reports
    | DeleteBrand Brand
    | DeleteGood Good
    | DeleteMarket Market
    | AddEditReport Record.Msg
