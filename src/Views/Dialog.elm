module Views.Dialog exposing (view)

import Html exposing (Html)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options
import Material.Textfield as Textfield
import Model exposing (Model, Msg(DialogMsg, Mdl))
import Models.Dialog exposing (DialogView(..), Msg(..))


view : Model -> Html Model.Msg
view model =
    let
        dialogView_ =
            dialogView model
    in
        case model.dialogView of
            Default ->
                dialogView_ "" [] []

            AddBrand name ->
                dialogView_ "Add Brand"
                    [ Textfield.render Mdl
                        [ 1 ]
                        model.mdl
                        [ Options.onInput <|
                            (\newValue ->
                                DialogMsg <| BrandUpdate newValue
                            )
                        , Textfield.label "Name"
                        , Textfield.floatingLabel
                        , Textfield.text_
                        , Textfield.value name
                        ]
                        []
                    ]
                    [ Button.render Mdl
                        [ 2 ]
                        model.mdl
                        [ Button.raised
                        , Button.colored
                        , Button.ripple
                        , Dialog.closeOn "click"
                        , Options.onClick <| DialogMsg <| BrandAdd name
                        ]
                        [ Html.text "Save" ]
                    ]


dialogView : Model -> String -> List (Html Model.Msg) -> List (Html Model.Msg) -> Html Model.Msg
dialogView model title contents actions =
    Dialog.view []
        [ Dialog.title [] [ Html.text title ]
        , Dialog.content [] contents
        , Dialog.actions [] <|
            actions
                ++ [ Button.render Mdl
                        [ 0 ]
                        model.mdl
                        [ Dialog.closeOn "click" ]
                        [ Html.text "Close" ]
                   ]
        ]
