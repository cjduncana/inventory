module Models.Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , Default
            , EditGood
            , EditView
            )
        , Msg
            ( BrandAdd
            , BrandAddDialog
            , EditDialog
            , GoodAdd
            , GoodAddDialog
            , GoodEdit
            , GoodEditDialog
            , MarketAdd
            , MarketAddDialog
            , NameUpdate
            , ObjectEdit
            )
        , mapName
        )

import Models.Brand exposing (Brand)
import Models.Good exposing (Good, ImageURI)
import Models.List exposing (ListObject)
import Models.Market exposing (Markets)


type Msg
    = NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | GoodAdd String ImageURI
    | GoodAddDialog
    | GoodEdit Good
    | GoodEditDialog Good
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject


type DialogView
    = Default
    | AddBrand String
    | AddGood String ImageURI (Maybe Brand) Markets
    | EditGood Good String ImageURI
    | AddMarket String
    | EditView ListObject String


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        AddGood name uri maybeBrand markets ->
            AddGood (f name) uri maybeBrand markets

        EditGood good name uri ->
            EditGood good (f name) uri

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name
