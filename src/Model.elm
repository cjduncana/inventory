module Model exposing (..)

import Material
import Models.Brand exposing (Brand)
import Models.Dialog as Dialog exposing (DialogView(Default))
import Models.Header as Header exposing (Header)
import RemoteData exposing (RemoteData)
import Routing.Error exposing (Error)
import Routing.Routes exposing (Route(Home))
import Uuid exposing (Uuid)


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
    { brands : RemoteData Error (List Brand) }


initStoredData : StoredData
initStoredData =
    StoredData RemoteData.NotAsked


type Msg
    = Mdl (Material.Msg Msg)
    | NavigateTo Route
    | DialogMsg Dialog.Msg
    | BrandsRecieved (List Brand)
    | DeleteBrand Uuid
