port module Models.Market
    exposing
        ( Market
        , Markets
        , createMarket
        , editMarket
        , getMarkets
        , deleteMarket
        , destroyMarket
        , restoreMarket
        , marketsReceived
        )

import Json.Encode exposing (Value)
import Models.List as List
import Models.Utilities as ModelUtil
import Uuid exposing (Uuid)


type alias Market =
    { id : Uuid
    , name : String
    }


type alias Markets =
    List Market


createMarket : String -> Cmd msg
createMarket =
    createMarketPort


editMarket : Market -> Cmd msg
editMarket =
    editMarketPort << List.toValue


getMarkets : Markets -> Cmd msg
getMarkets storedMarkets =
    ModelUtil.commandIfEmpty (getMarketsPort ()) storedMarkets


deleteMarket : Uuid -> Cmd msg
deleteMarket =
    deleteMarketPort << Uuid.toString


destroyMarket : Uuid -> Cmd msg
destroyMarket =
    destroyMarketPort << Uuid.toString


restoreMarket : Uuid -> Cmd msg
restoreMarket =
    restoreMarketPort << Uuid.toString


marketsReceived : (Markets -> msg) -> Sub msg
marketsReceived =
    marketsReceivedPort << List.fromValues


port createMarketPort : String -> Cmd msg


port editMarketPort : Value -> Cmd msg


port getMarketsPort : () -> Cmd msg


port deleteMarketPort : String -> Cmd msg


port destroyMarketPort : String -> Cmd msg


port restoreMarketPort : String -> Cmd msg


port marketsReceivedPort : (Value -> msg) -> Sub msg
