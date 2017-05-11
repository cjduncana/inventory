module Model exposing (..)

import Material
import Material.Snackbar as Snackbar
import Models.Brand exposing (Brands)
import Models.Dialog as Dialog exposing (DialogView(Default))
import Models.Error exposing (Error)
import Models.Header as Header exposing (Header)
import Models.List exposing (ListObject, ListType)
import Models.Market exposing (Markets)
import Routing.Routes exposing (Route(Home))


type alias Model =
    { mdl : Material.Model
    , route : Route
    , storedData : StoredData
    , header : Header
    , dialogView : DialogView
    , snackbar : Snackbar.Model SnackbarPayload
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    , route = Home
    , storedData = initStoredData
    , header = Header.init
    , dialogView = Default
    , snackbar = Snackbar.model
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Material.init Mdl )


type alias StoredData =
    { brands : Brands
    , markets : Markets
    }


initStoredData : StoredData
initStoredData =
    StoredData [] []


type Msg
    = Mdl (Material.Msg Msg)
    | SnackbarMsg (Snackbar.Msg SnackbarPayload)
    | NavigateTo Route
    | ErrorReceived Error
    | DialogMsg Dialog.Msg
    | BrandsReceived Brands
    | MarketsReceived Markets
    | DeleteObject (ListType ListObject)


type SnackbarPayload
    = Empty
