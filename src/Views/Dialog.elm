module Views.Dialog exposing (view)

import Html exposing (Html)
import Html.Events as Events
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options
import Material.Textfield as Textfield
import Model exposing (Model, Msg(AddFileDialog, DialogMsg, Mdl))
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
        , Msg
            ( BrandAdd
            , GoodAdd
            , GoodEdit
            , MarketAdd
            , NameUpdate
            , ObjectEdit
            )
        )
import Models.Good exposing (Good, ImageURI)
import Models.List exposing (ListObject)
import Views.Utilities as ViewUtil


view : Model -> Html Model.Msg
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

            AddGood name uri _ _ ->
                addGoodDialogView <|
                    AEGoodContents "Good" name uri <|
                        GoodAdd name uri

            EditGood good name uri ->
                editGoodDialogView <|
                    AEGoodContents good.name name uri <|
                        GoodEdit <|
                            Good good.id name uri Nothing []

            AddMarket name ->
                addDialogView <|
                    AddEditDialogContents "Market" name <|
                        MarketAdd name

            EditView object name ->
                editDialogView <|
                    AddEditDialogContents object.name name <|
                        ObjectEdit <|
                            ListObject object.id name


addEditDialogView : AddEditText -> Model -> AddEditDialogContents -> Html Model.Msg
addEditDialogView { viewType, buttonText } model { title, name, onSubitMsg } =
    dialogView model (Just onSubitMsg) <|
        DialogContents
            (viewType ++ " " ++ title)
            [ textfield model NameUpdate name ]
            [ button model buttonText ]


addEditGoodDialogView : AddEditText -> Model -> AEGoodContents -> Html Model.Msg
addEditGoodDialogView { viewType, buttonText } model content =
    dialogView model (Just content.onSubitMsg) <|
        DialogContents
            (viewType ++ " " ++ content.title)
            [ textfield model NameUpdate content.name
            , Options.img (ViewUtil.square 200)
                [ ViewUtil.imageSrc content.uri ]
            , Button.render Mdl
                [ 2 ]
                model.mdl
                [ Button.raised
                , Button.ripple
                , Button.type_ "button"
                , Options.onClick AddFileDialog
                ]
                [ Html.text "Upload Image" ]
            ]
            [ button model buttonText ]


dialogView : Model -> Maybe Models.Dialog.Msg -> DialogContents -> Html Model.Msg
dialogView model onSubitMsg { title, contents, actions } =
    let
        attributes =
            Maybe.withDefault [] <|
                Maybe.map
                    (List.singleton
                        << Events.onSubmit
                        << DialogMsg
                    )
                    onSubitMsg

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


textfield : Model -> (String -> Models.Dialog.Msg) -> String -> Html Model.Msg
textfield model onInputMsg name =
    Textfield.render Mdl
        [ 1 ]
        model.mdl
        [ Options.onInput <| DialogMsg << onInputMsg
        , Textfield.label "Name"
        , Textfield.floatingLabel
        , Textfield.text_
        , Textfield.value name
        ]
        []


button : Model -> String -> Html Model.Msg
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
    , name : String
    , uri : ImageURI
    , onSubitMsg : Models.Dialog.Msg
    }


type alias DialogContents =
    { title : String
    , contents : List (Html Model.Msg)
    , actions : List (Html Model.Msg)
    }
