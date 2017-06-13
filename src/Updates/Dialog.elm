module Updates.Dialog exposing (changeImage, update)

import Dropdown
import Material
import Maybe.Extra as Maybe
import Model exposing (Model)
import Models.Brand as Brand
import Models.Dialog as Dialog exposing (Msg)
import Models.Dropdown as Dropdown
import Models.Good as Good exposing (ImageURI(HasImage, NoImage))
import Models.Market as Market
import Routing.Routes as Routes
import Routing.Reports as Reports


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.route ) of
        ( Dialog.Mdl msg_, _ ) ->
            Material.update Dialog.Mdl msg_ model

        ( Dialog.NameUpdate name, _ ) ->
            Cmd.none
                |> (,)
                    { model
                        | dialogView =
                            Dialog.mapName
                                (always name)
                                model.dialogView
                    }

        ( Dialog.BrandAdd name, _ ) ->
            Brand.createBrand
                |> commandIfHasName name
                |> (,) { model | dialogView = Dialog.AddBrand "" }

        ( Dialog.BrandAddDialog, _ ) ->
            Cmd.none
                |> (,) { model | dialogView = Dialog.AddBrand "" }

        ( Dialog.GoodAdd name data, _ ) ->
            flip Good.createGood data
                |> commandIfHasName name
                |> (,) { model | dialogView = Dialog.newAddGoodView }

        ( Dialog.GoodAddDialog, _ ) ->
            Cmd.none
                |> (,) { model | dialogView = Dialog.newAddGoodView }

        ( Dialog.GoodEdit good, _ ) ->
            always (Good.editGood good)
                |> commandIfHasName (Good.getName good)
                |> (,) { model | dialogView = Dialog.newAddGoodView }

        ( Dialog.GoodEditDialog good, _ ) ->
            Cmd.none
                |> (,) { model | dialogView = Dialog.newEditGoodView good }

        ( Dialog.GoodBrandChange maybeBrand, _ ) ->
            Cmd.none
                |> (,)
                    { model
                        | dialogView =
                            Dialog.setBrand
                                maybeBrand
                                model.dialogView
                    }

        ( Dialog.GoodMarketAdd maybeMarket, _ ) ->
            Cmd.none
                |> (,)
                    { model
                        | dialogView =
                            Dialog.addMarket
                                maybeMarket
                                model.dialogView
                    }

        ( Dialog.GoodMarketRemove index, _ ) ->
            Cmd.none
                |> (,)
                    { model
                        | dialogView =
                            Dialog.removeMarket
                                index
                                model.dialogView
                    }

        ( Dialog.MarketAdd name, _ ) ->
            Market.createMarket
                |> commandIfHasName name
                |> (,) { model | dialogView = Dialog.AddMarket "" }

        ( Dialog.MarketAddDialog, _ ) ->
            Cmd.none
                |> (,) { model | dialogView = Dialog.AddMarket "" }

        ( Dialog.EditDialog object, _ ) ->
            Cmd.none
                |> (,)
                    { model
                        | dialogView = Dialog.EditView object object.name
                    }

        ( Dialog.ObjectEdit object, Routes.Brands ) ->
            always (Brand.editBrand object)
                |> commandIfHasName object.name
                |> (,) { model | dialogView = Dialog.AddBrand "" }

        ( Dialog.ObjectEdit object, Routes.Markets ) ->
            always (Market.editMarket object)
                |> commandIfHasName object.name
                |> (,) { model | dialogView = Dialog.AddMarket "" }

        ( Dialog.ObjectEdit _, _ ) ->
            ( model, Cmd.none )

        ( Dialog.AddFileDialog, _ ) ->
            ( model, Dialog.addFileDialog )

        ( Dialog.ImageSaved filename, _ ) ->
            changeImage model <| Just filename

        ( Dialog.RemoveImage, _ ) ->
            changeImage model Nothing

        ( Dialog.BrandDropdownMsg msg_, _ ) ->
            case model.dialogView of
                Dialog.AddGood goodContent ->
                    Dropdown.update Dropdown.brandConfig
                        msg_
                        goodContent.brandDropdown
                        |> Tuple.mapFirst
                            (\newDropdown ->
                                { model
                                    | dialogView =
                                        Dialog.AddGood
                                            { goodContent
                                                | brandDropdown = newDropdown
                                            }
                                }
                            )

                Dialog.EditGood good goodContent ->
                    Dropdown.update Dropdown.brandConfig
                        msg_
                        goodContent.brandDropdown
                        |> Tuple.mapFirst
                            (\newDropdown ->
                                { model
                                    | dialogView =
                                        Dialog.EditGood good
                                            { goodContent
                                                | brandDropdown = newDropdown
                                            }
                                }
                            )

                _ ->
                    ( model, Cmd.none )

        ( Dialog.MarketDropdownMsg msg_, _ ) ->
            case model.dialogView of
                Dialog.AddGood goodContent ->
                    Dropdown.update Dropdown.marketConfig
                        msg_
                        goodContent.marketDropdown
                        |> Tuple.mapFirst
                            (\newDropdown ->
                                { model
                                    | dialogView =
                                        Dialog.AddGood
                                            { goodContent
                                                | marketDropdown = newDropdown
                                            }
                                }
                            )

                Dialog.EditGood good goodContent ->
                    Dropdown.update Dropdown.marketConfig
                        msg_
                        goodContent.marketDropdown
                        |> Tuple.mapFirst
                            (\newDropdown ->
                                { model
                                    | dialogView =
                                        Dialog.EditGood good
                                            { goodContent
                                                | marketDropdown = newDropdown
                                            }
                                }
                            )

                _ ->
                    ( model, Cmd.none )

        ( Dialog.NewReportPage, Routes.Reports ) ->
            Reports.gotoNew model

        ( Dialog.NewReportPage, _ ) ->
            ( model, Cmd.none )


commandIfHasName : String -> (String -> Cmd msg) -> Cmd msg
commandIfHasName name function =
    Just name
        |> Maybe.filter (not << String.isEmpty)
        |> Maybe.map function
        |> Maybe.withDefault Cmd.none


changeImage : Model -> Maybe String -> ( Model, Cmd Msg )
changeImage model filename =
    Maybe.next filename (Dialog.getFilename model.dialogView)
        |> Maybe.map Dialog.removeImage
        |> Maybe.withDefault Cmd.none
        |> (,) filename
        |> Tuple.mapFirst
            (Maybe.map HasImage
                >> Maybe.withDefault NoImage
                >> \uri ->
                    { model
                        | dialogView = Dialog.setImage uri model.dialogView
                    }
            )
