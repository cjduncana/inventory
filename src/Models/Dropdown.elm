module Models.Dropdown exposing (dropdownConfig)

import Dropdown
import Models.Brand exposing (Brand)
import Models.Dialog exposing (Msg(GoodBrandChange))


dropdownConfig : Dropdown.Config Msg Brand
dropdownConfig =
    Dropdown.newConfig GoodBrandChange .name
        |> Dropdown.withPrompt "Add Brand"
        |> Dropdown.withTriggerStyles [ ( "width", "150px" ) ]
