module Models.Dropdown exposing (brandConfig, marketConfig)

import Dropdown
import Models.Brand exposing (Brand)
import Models.Dialog exposing (Msg(GoodBrandChange, GoodMarketAdd))
import Models.Market exposing (Market)


brandConfig : Dropdown.Config Msg Brand
brandConfig =
    Dropdown.newConfig GoodBrandChange .name
        |> Dropdown.withPrompt "Add Brand"
        |> styles


marketConfig : Dropdown.Config Msg Market
marketConfig =
    Dropdown.newConfig GoodMarketAdd .name
        |> Dropdown.withPrompt "Select Market"
        |> styles


styles : Dropdown.Config Msg item -> Dropdown.Config Msg item
styles =
    Dropdown.withTriggerStyles [ ( "width", "150px" ) ]
        >> Dropdown.withItemStyles
            [ ( "border-left", "1px solid black" )
            , ( "border-right", "1px solid black" )
            , ( "border-bottom", "1px solid black" )
            ]
