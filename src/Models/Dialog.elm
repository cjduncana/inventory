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
import Models.Good as Good exposing (Good, GoodData, ImageURI(NoImage))
import Models.ID exposing (ID)
import Models.Market exposing (Market, Markets)
import Uuid


type Msg
    = Mdl (Material.Msg Msg)
    | NameUpdate String
    | BrandAdd String
    | BrandAddDialog
    | GoodAdd String GoodData
    | GoodAddDialog
    | GoodEdit Good
    | GoodEditDialog Good
    | MarketAdd String
    | MarketAddDialog
    | ObjectEdit ID
    | EditDialog ID
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
    | EditView ID String


type alias EditableGood =
    { brandDropdown : Dropdown.State
    , marketDropdown : Dropdown.State
    , name : String
    , data : GoodData
    }


newAddGoodView : DialogView
newAddGoodView =
    AddGood
        { brandDropdown = Dropdown.newState "brand"
        , marketDropdown = Dropdown.newState "market"
        , name = ""
        , data = GoodData NoImage Nothing []
        }


newEditGoodView : Good -> DialogView
newEditGoodView good =
    EditGood good
        { brandDropdown = Dropdown.newState "brand"
        , marketDropdown = Dropdown.newState "market"
        , name = Good.getName good
        , data = Tuple.second good
        }


getFilename : DialogView -> Maybe String
getFilename dialogView =
    case dialogView of
        AddGood { data } ->
            Good.getFilename data.image

        EditGood _ { data } ->
            Good.getFilename data.image

        _ ->
            Nothing


addMarket : Maybe Market -> DialogView -> DialogView
addMarket maybeMarket dialogView =
    let
        f data =
            case maybeMarket of
                Just market ->
                    { data
                        | markets =
                            market
                                :: data.markets
                                |> List.uniqueBy (.uuid >> Uuid.toString)
                                |> List.sortBy .name
                    }

                Nothing ->
                    data
    in
        case dialogView of
            AddGood good ->
                AddGood { good | data = f good.data }

            EditGood original good ->
                EditGood original { good | data = f good.data }

            _ ->
                dialogView


removeMarket : Int -> DialogView -> DialogView
removeMarket index dialogView =
    let
        f data =
            { data
                | markets = List.removeAt index data.markets
            }
    in
        case dialogView of
            AddGood good ->
                AddGood { good | data = f good.data }

            EditGood original good ->
                EditGood original { good | data = f good.data }

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
    let
        f data =
            { data | brand = maybeBrand }
    in
        case dialogView of
            AddGood good ->
                AddGood { good | data = f good.data }

            EditGood original good ->
                EditGood original { good | data = f good.data }

            _ ->
                dialogView


setImage : ImageURI -> DialogView -> DialogView
setImage uri dialogView =
    let
        f data =
            { data | image = uri }
    in
        case dialogView of
            AddGood good ->
                AddGood { good | data = f good.data }

            EditGood original good ->
                EditGood original { good | data = f good.data }

            _ ->
                dialogView


addFileDialog : Cmd msg
addFileDialog =
    addFileDialogPort ()


port addFileDialogPort : () -> Cmd msg


port imageSaved : (String -> msg) -> Sub msg


port removeImage : String -> Cmd msg
