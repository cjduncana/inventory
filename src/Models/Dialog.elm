module Models.Dialog exposing (..)

import Models.List exposing (ListObject)


type Msg
    = NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject


type DialogView
    = Default
    | AddBrand String
    | AddMarket String
    | EditView ListObject String


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name
