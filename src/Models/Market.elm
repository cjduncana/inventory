port module Models.Market exposing (..)

import Uuid exposing (Uuid)


type alias Market =
    { id : Uuid
    , name : String
    }


type alias Markets =
    List Market


type alias MarketJson =
    { id : String
    , name : String
    }


createMarket : String -> Cmd msg
createMarket =
    createMarketPort


editMarket : Market -> Cmd msg
editMarket =
    editMarketPort << toJson


getMarkets : Cmd msg
getMarkets =
    getMarketsPort ()


deleteMarket : Uuid -> Cmd msg
deleteMarket =
    deleteMarketPort << Uuid.toString


marketsReceived : (Markets -> msg) -> Sub msg
marketsReceived f =
    marketsReceivedPort <| f << fromJsonList


doCommand : String -> Cmd msg -> Cmd msg
doCommand name cmd =
    if String.isEmpty name then
        Cmd.none
    else
        cmd


fromJson : MarketJson -> Maybe Market
fromJson json =
    Maybe.map (flip Market json.name) <|
        Uuid.fromString json.id


fromJsonList : List MarketJson -> Markets
fromJsonList =
    List.filterMap fromJson


toJson : Market -> MarketJson
toJson market =
    MarketJson (Uuid.toString market.id) market.name


port createMarketPort : String -> Cmd msg


port editMarketPort : MarketJson -> Cmd msg


port getMarketsPort : () -> Cmd msg


port deleteMarketPort : String -> Cmd msg


port marketsReceivedPort : (List MarketJson -> msg) -> Sub msg
