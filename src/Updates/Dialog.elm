module Updates.Dialog exposing (update)

import Model exposing (Model)
import Models.Brand as Brand exposing (Brand)
import Models.Dialog exposing (DialogView(AddBrand), Msg(..))


update : Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case msg of
        BrandUpdate name ->
            ( { model | dialogView = AddBrand name }, Cmd.none )

        BrandAdd name ->
            let
                model_ =
                    { model | dialogView = AddBrand "" }

                command_ =
                    if String.isEmpty name then
                        Cmd.none
                    else
                        Brand.createBrand name
            in
                ( model_, command_ )
