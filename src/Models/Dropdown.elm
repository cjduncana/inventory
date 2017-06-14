module Models.Dropdown exposing (brandConfig, goodConfig, marketConfig)

import Dropdown
import Models.Brand exposing (Brand)
import Models.Dialog exposing (Msg(GoodBrandChange, GoodMarketAdd))
import Models.Good as Good exposing (Good)
import Models.Market exposing (Market)
import Models.Record exposing (FormMsg(GoodUpdate))
import Translation.Main as T


brandConfig : Dropdown.Config Msg Brand
brandConfig =
    Dropdown.newConfig GoodBrandChange .name
        |> Dropdown.withPrompt T.addBrand
        |> styles


goodConfig : Int -> Dropdown.Config FormMsg Good
goodConfig index =
    Dropdown.newConfig (GoodUpdate index) Good.getName
        |> Dropdown.withPrompt T.addGood
        |> styles


marketConfig : Dropdown.Config Msg Market
marketConfig =
    Dropdown.newConfig GoodMarketAdd .name
        |> Dropdown.withPrompt T.selectMarket
        |> styles


styles : Dropdown.Config msg item -> Dropdown.Config msg item
styles =
    Dropdown.withTriggerStyles [ ( "width", "150px" ) ]
        >> Dropdown.withItemStyles
            [ ( "border-left", "1px solid black" )
            , ( "border-right", "1px solid black" )
            , ( "border-bottom", "1px solid black" )
            ]
