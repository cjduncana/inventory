module Model exposing (..)

import Material
import Models.Brand exposing (Brand)
import Models.Dialog as Dialog exposing (DialogView(Default))
import Models.Header as Header exposing (Header)
import Routing.Routes exposing (Route(Home))


type alias Model =
    { mdl : Material.Model
    , route : Route
    , storedData : StoredData
    , header : Header
    , dialogView : DialogView
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    , route = Home
    , storedData = initStoredData
    , header = Header.init
    , dialogView = Default
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Material.init Mdl )


type alias StoredData =
    { brands : Maybe (List Brand) }


initStoredData : StoredData
initStoredData =
    StoredData Nothing


type Msg
    = Mdl (Material.Msg Msg)
    | NavigateTo Route
    | DialogMsg Dialog.Msg
    | GetBrands
    | BrandsRecieved (List Brand)
