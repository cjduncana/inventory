port module Models.Dialog
    exposing
        ( DialogView
            ( AddBrand
            , AddGood
            , AddMarket
            , Default
            , EditGood
            , EditView
            )
        , EditableGood
        , Msg
            ( AddFileDialog
            , BrandAdd
            , BrandAddDialog
            , BrandDropdownMsg
            , EditDialog
            , GoodAdd
            , GoodAddDialog
            , GoodBrandChange
            , GoodEdit
            , GoodEditDialog
            , GoodMarketAdd
            , GoodMarketRemove
            , ImageSaved
            , MarketAdd
            , MarketAddDialog
            , MarketDropdownMsg
            , Mdl
            , NameUpdate
            , ObjectEdit
            , RemoveImage
            )
        , addFileDialog
        , addMarket
        , getFilename
        , imageSaved
        , mapName
        , newAddGoodView
        , newEditGoodView
        , setBrand
        , setImage
        , removeImage
        , removeMarket
        )

import Dropdown
import List.Extra as List
import Material
import Models.Brand exposing (Brand)
import Models.Good exposing (Good, ImageURI(NoImage))
import Models.List exposing (ListObject)
import Models.Market exposing (Market, Markets)
import Uuid


type Msg
    = Mdl (Material.Msg Msg)
    | NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | GoodAdd String ImageURI (Maybe Brand) Markets
    | GoodAddDialog
    | GoodEdit Good
    | GoodEditDialog Good
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ListObject
    | EditDialog ListObject
    | AddFileDialog
    | ImageSaved String
    | RemoveImage
    | BrandDropdownMsg (Dropdown.Msg Brand)
    | GoodBrandChange (Maybe Brand)
    | MarketDropdownMsg (Dropdown.Msg Market)
    | GoodMarketAdd (Maybe Market)
    | GoodMarketRemove Int


type DialogView
    = Default
    | AddBrand String
    | AddGood EditableGood
    | EditGood Good EditableGood
    | AddMarket String
    | EditView ListObject String


type alias EditableGood =
    { brandDropdown : Dropdown.State
    , marketDropdown : Dropdown.State
    , name : String
    , image : ImageURI
    , brand : Maybe Brand
    , markets : Markets
    }


newAddGoodView : DialogView
newAddGoodView =
    AddGood
        { brandDropdown = Dropdown.newState "brand"
        , marketDropdown = Dropdown.newState "market"
        , name = ""
        , image = NoImage
        , brand = Nothing
        , markets = []
        }


newEditGoodView : Good -> DialogView
newEditGoodView good =
    EditGood good
        { brandDropdown = Dropdown.newState "brand"
        , marketDropdown = Dropdown.newState "market"
        , name = good.name
        , image = good.image
        , brand = good.brand
        , markets = good.markets
        }


getFilename : DialogView -> Maybe String
getFilename dialogView =
    case dialogView of
        AddGood { image } ->
            Models.Good.getFilename image

        EditGood _ { image } ->
            Models.Good.getFilename image

        _ ->
            Nothing


addMarket : Maybe Market -> DialogView -> DialogView
addMarket maybeMarket dialogView =
    let
        f markets =
            case maybeMarket of
                Just market ->
                    market
                        :: markets
                        |> List.uniqueBy (.id >> Uuid.toString)
                        |> List.sortBy .name

                Nothing ->
                    markets
    in
        case dialogView of
            AddGood good ->
                AddGood { good | markets = f good.markets }

            EditGood original good ->
                EditGood original { good | markets = f good.markets }

            _ ->
                dialogView


removeMarket : Int -> DialogView -> DialogView
removeMarket index dialogView =
    case dialogView of
        AddGood good ->
            AddGood { good | markets = List.removeAt index good.markets }

        EditGood original good ->
            EditGood original
                { good
                    | markets = List.removeAt index good.markets
                }

        _ ->
            dialogView


mapName : (String -> String) -> DialogView -> DialogView
mapName f dialogView =
    case dialogView of
        Default ->
            Default

        AddBrand name ->
            AddBrand <| f name

        AddGood good ->
            AddGood { good | name = f good.name }

        EditGood original good ->
            EditGood original { good | name = f good.name }

        AddMarket name ->
            AddMarket <| f name

        EditView object name ->
            EditView object <| f name


setBrand : Maybe Brand -> DialogView -> DialogView
setBrand maybeBrand dialogView =
    case dialogView of
        AddGood good ->
            AddGood { good | brand = maybeBrand }

        EditGood original good ->
            EditGood original { good | brand = maybeBrand }

        _ ->
            dialogView


setImage : ImageURI -> DialogView -> DialogView
setImage uri dialogView =
    case dialogView of
        AddGood good ->
            AddGood { good | image = uri }

        EditGood original good ->
            EditGood original { good | image = uri }

        _ ->
            dialogView


addFileDialog : Cmd msg
addFileDialog =
    addFileDialogPort ()


port addFileDialogPort : () -> Cmd msg


port imageSaved : (String -> msg) -> Sub msg


port removeImage : String -> Cmd msg
