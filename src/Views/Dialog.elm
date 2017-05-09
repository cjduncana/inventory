module Views.Dialog exposing (view)

import Html exposing (Html)
import Html.Events as Events
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options
import Material.Textfield as Textfield
import Model exposing (Model, Msg(DialogMsg, Mdl))
import Models.Dialog exposing (DialogView(..), Msg(..))
import Models.List exposing (ListObject)
import Views.Utilities as ViewUtil


view : Model -> Html Model.Msg
view model =
    let
        dialogView_ =
            dialogView model

        addDialogView_ =
            addDialogView model

        editDialogView_ =
            editDialogView model
    in
        case model.dialogView of
            Default ->
                dialogView_ Nothing <| DialogContents "" [] []

            AddBrand name ->
                addDialogView_ <|
                    AddEditDialogContents "Brand" name <|
                        BrandAdd name

            AddMarket name ->
                addDialogView_ <|
                    AddEditDialogContents "Market" name <|
                        MarketAdd name

            EditView object name ->
                editDialogView_ <|
                    AddEditDialogContents object.name name <|
                        ObjectEdit <|
                            ListObject object.id name


addDialogView : Model -> AddEditDialogContents -> Html Model.Msg
addDialogView =
    addEditDialogView <| AddEditText "Add" "Save"


editDialogView : Model -> AddEditDialogContents -> Html Model.Msg
editDialogView =
    addEditDialogView <| AddEditText "Edit" "Edit"


addEditDialogView : AddEditText -> Model -> AddEditDialogContents -> Html Model.Msg
addEditDialogView { viewType, buttonText } model { title, name, onSubitMsg } =
    dialogView model (Just onSubitMsg) <|
        DialogContents
            (viewType ++ " " ++ title)
            [ textfield model NameUpdate name ]
            [ button model viewType ]


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
                , Dialog.content [] contents
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


type alias AddEditDialogContents =
    { title : String
    , name : String
    , onSubitMsg : Models.Dialog.Msg
    }


type alias DialogContents =
    { title : String
    , contents : List (Html Model.Msg)
    , actions : List (Html Model.Msg)
    }
