module Routing.Brands exposing (goto)

import Model exposing (Model, Msg)
import Models.Brand as Brand
import Models.Dialog exposing (DialogView(AddBrand))
import Models.Header exposing (Header, Fab(Add))
import Routing.Routes exposing (Route(Brands))


goto : Model -> ( Model, Cmd Msg )
goto model =
    let
        maybeBrands =
            model.storedData.brands

        command =
            case maybeBrands of
                Nothing ->
                    Brand.getBrands ()

                Just _ ->
                    Cmd.none

        model_ =
            { model
                | route = Brands maybeBrands
                , header = Header "Brands List" Add
                , dialogView = AddBrand ""
            }
    in
        ( model_, command )
