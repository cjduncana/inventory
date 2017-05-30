module Views.Dialog exposing (view)

import Dropdown
import Html exposing (Html)
import Html.Events as Events
import List.Extra as List
import Material.Button as Button
import Material.Chip as Chip
import Material.Dialog as Dialog
import Material.Options as Options
import Material.Textfield as Textfield
import Model exposing (Model)
import Models.Dialog
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
            , BrandDropdownMsg
            , GoodAdd
            , GoodEdit
            , GoodMarketRemove
            , MarketAdd
            , MarketDropdownMsg
            , Mdl
            , NameUpdate
            , ObjectEdit
            , RemoveImage
            )
        )
import Models.Dropdown as Dropdown
import Models.Good exposing (Good, ImageURI)
import Models.List exposing (ListObject)
import Models.Market exposing (Market, Markets)
import Views.Utilities as ViewUtil


view : Model -> Html Msg
view model =
    let
        dialogView_ =
            dialogView model

        addDialogView =
            addEditDialogView addText model

        addGoodDialogView =
            addEditGoodDialogView addText model

        editDialogView =
            addEditDialogView editText model

        editGoodDialogView =
            addEditGoodDialogView editText model
    in
        case model.dialogView of
            Default ->
                dialogView_ Nothing <| DialogContents "" [] []

            AddBrand name ->
                addDialogView <|
                    AddEditDialogContents "Brand" name <|
                        BrandAdd name

            AddGood goodContent ->
                addGoodDialogView <|
                    AEGoodContents "Good" goodContent <|
                        GoodAdd goodContent.name
                            goodContent.image
                            goodContent.brand
                            goodContent.markets

            EditGood good goodContent ->
                Good good.id
                    goodContent.name
                    goodContent.image
                    goodContent.brand
                    goodContent.markets
                    |> GoodEdit
                    |> AEGoodContents good.name goodContent
                    |> editGoodDialogView

            AddMarket name ->
                addDialogView <|
                    AddEditDialogContents "Market" name <|
                        MarketAdd name

            EditView object name ->
                editDialogView <|
                    AddEditDialogContents object.name name <|
                        ObjectEdit <|
                            ListObject object.id name


addEditDialogView : AddEditText -> Model -> AddEditDialogContents -> Html Msg
addEditDialogView { viewType, buttonText } model { title, name, onSubitMsg } =
    dialogView model (Just onSubitMsg) <|
        DialogContents
            (viewType ++ " " ++ title)
            [ textfield model NameUpdate name ]
            [ button model buttonText ]


addEditGoodDialogView : AddEditText -> Model -> AEGoodContents -> Html Msg
addEditGoodDialogView { viewType, buttonText } model { title, goodContent, onSubitMsg } =
    dialogView model (Just onSubitMsg) <|
        DialogContents
            (viewType ++ " " ++ title)
            [ textfield model NameUpdate goodContent.name
            , Options.img (ViewUtil.square 200)
                [ ViewUtil.imageSrc goodContent.image ]
            , Options.div [ Options.center ]
                [ Button.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Button.raised
                    , Button.ripple
                    , Button.type_ "button"
                    , Options.css "margin" "10px 5px"
                    , Options.onClick AddFileDialog
                    ]
                    [ Html.text "Upload" ]
                , Button.render Mdl
                    [ 3 ]
                    model.mdl
                    [ Button.raised
                    , Button.ripple
                    , Button.type_ "button"
                    , Options.css "margin" "10px 5px"
                    , Options.onClick RemoveImage
                    ]
                    [ Html.text "Remove" ]
                ]
            , Dropdown.view Dropdown.brandConfig
                goodContent.brandDropdown
                model.storedData.brands
                goodContent.brand
                |> Html.map BrandDropdownMsg
            , marketChips goodContent model.storedData.markets
            ]
            [ button model buttonText ]


dialogView : Model -> Maybe Msg -> DialogContents -> Html Msg
dialogView model onSubitMsg { title, contents, actions } =
    let
        attributes =
            Maybe.withDefault [] <|
                Maybe.map (List.singleton << Events.onSubmit) onSubitMsg

        actions_ =
            List.append actions
                [ Button.render Mdl
                    [ 0 ]
                    model.mdl
                    [ Button.type_ "button"
                    , Dialog.closeOn "click"
                    ]
                    [ Html.text "Close" ]
                ]
    in
        Html.form attributes
            [ Dialog.view []
                [ Dialog.title (ViewUtil.noWrap 1) [ Html.text title ]
                , Dialog.content
                    [ Options.css "display" "flex"
                    , Options.css "flex-direction" "column"
                    , Options.css "align-items" "center"
                    ]
                    contents
                , Dialog.actions [] actions_
                ]
            ]


textfield : Model -> (String -> Msg) -> String -> Html Msg
textfield model onInputMsg name =
    Textfield.render Mdl
        [ 1 ]
        model.mdl
        [ Options.onInput onInputMsg
        , Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text_
        , Textfield.value name
        ]
        []


button : Model -> String -> Html Msg
button model buttonText =
    Button.render Mdl
        [ 2 ]
        model.mdl
        [ Button.raised
        , Button.colored
        , Button.ripple
        , Button.type_ "submit"
        , Dialog.closeOn "click"
        ]
        [ Html.text buttonText ]


marketChips : EditableGood -> Markets -> Html Msg
marketChips goodContent allMarkets =
    let
        otherMarkets =
            List.filterNot (flip List.member goodContent.markets) allMarkets
    in
        Html.div []
            [ Html.div [] <|
                if List.isEmpty goodContent.markets then
                    [ Html.text "Choose Markets below" ]
                else
                    List.indexedMap marketChip goodContent.markets
            , Dropdown.view Dropdown.marketConfig
                goodContent.marketDropdown
                otherMarkets
                Nothing
                |> Html.map MarketDropdownMsg
            ]


marketChip : Int -> Market -> Html Msg
marketChip index market =
    Chip.button
        [ Chip.deleteClick <| GoodMarketRemove index
        , Options.css "margin" "5px"
        ]
        [ Chip.content [] [ Html.text market.name ]
        ]


type alias AddEditText =
    { viewType : String
    , buttonText : String
    }


addText : AddEditText
addText =
    AddEditText "Add" "Save"


editText : AddEditText
editText =
    AddEditText "Edit" "Edit"


type alias AddEditDialogContents =
    { title : String
    , name : String
    , onSubitMsg : Models.Dialog.Msg
    }


type alias AEGoodContents =
    { title : String
    , goodContent : EditableGood
    , onSubitMsg : Models.Dialog.Msg
    }


type alias DialogContents =
    { title : String
    , contents : List (Html Msg)
    , actions : List (Html Msg)
    }
