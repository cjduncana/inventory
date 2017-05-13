module Models.Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , Default
            , EditView
            )
        , Msg
            ( BrandAdd
            , BrandAddDialog
            , EditDialog
            , GoodAdd
            , MarketAdd
            , MarketAddDialog
            , NameUpdate
            , ObjectEdit
            )
        , mapName
        )

import Models.Brand exposing (Brand)
import Models.List exposing (ListObject)
import Models.Market exposing (Markets)


type Msg
    = NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | GoodAdd String
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject


type DialogView
    = Default
    | AddBrand String
    | AddGood String String (Maybe Brand) Markets
    | AddMarket String
    | EditView ListObject String


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        AddGood name imageUrl maybeBrand markets ->
            AddGood (f name) imageUrl maybeBrand markets

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name
