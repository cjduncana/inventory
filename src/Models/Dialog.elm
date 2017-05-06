module Models.Dialog exposing (..)

import Models.Brand exposing (Brand)


type Msg
    = BrandNameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | BrandEdit Brand
    | BrandEditDialog Brand


type DialogView
    = Default
    | AddBrand String
    | EditBrand Brand String


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        EditBrand brand name ->
            EditBrand brand <| f name
