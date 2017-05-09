module Model exposing (..)

import Material
import Models.Brand exposing (Brand, RemoteBrands)
import Models.Dialog as Dialog exposing (DialogView(Default))
import Models.Error exposing (Error)
import Models.Header as Header exposing (Header)
import Models.List exposing (ListType)
import Models.Market exposing (Market, RemoteMarkets)
import RemoteData exposing (RemoteData(NotAsked))
import Routing.Routes exposing (Route(Home))
import Uuid exposing (Uuid)


type alias Model =
    { mdl : Material.Model
    , route : Route
    , storedData : StoredData
    , header : Header
    , dialogView : DialogView
    , error : Maybe Error
    , lastAction : ActionType
    }


initialModel : Model
initialModel =
    { mdl = Material.model
    , route = Home
    , storedData = initStoredData
    , header = Header.init
    , dialogView = Default
    , error = Nothing
    , lastAction = None
    }


init : ( Model, Cmd Msg )
init =
    ( initialModel, Material.init Mdl )


type alias StoredData =
    { brands : RemoteBrands
    , markets : RemoteMarkets
    }


initStoredData : StoredData
initStoredData =
    StoredData NotAsked NotAsked


type Msg
    = Mdl (Material.Msg Msg)
    | NavigateTo Route
    | ErrorRecieved Error
    | DialogMsg Dialog.Msg
    | BrandsRecieved (List Brand)
    | MarketsRecieved (List Market)
    | DeleteObject ListType Uuid


type ActionType
    = None
    | BrandAction Action
    | MarketAction Action


type Action
    = List
    | Create
    | Edit
    | Delete
