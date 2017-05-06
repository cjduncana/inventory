module Updates.Brands exposing (get, update, delete)

import Model exposing (Model, Msg, Action(..))
import Models.Brand as Brand exposing (Brand, Action(..))
import RemoteData exposing (RemoteData(Loading, Success))
import Routing.Routes exposing (Route(Brands))
import Utilities as Util
import Uuid exposing (Uuid)


get : Model -> ( Model, Cmd Msg )
get model =
    let
        route =
            case model.route of
                Brands brands ->
                    if Util.isNotSuccess brands then
                        Brands Loading
                    else
                        model.route

                _ ->
                    model.route

        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = Loading }

        model_ =
            { model
                | route = route
                , storedData = storedData_
                , lastAction = BrandAction Get
            }
    in
        ( model_, Brand.getBrands )


update : List Brand -> Model -> ( Model, Cmd Msg )
update brands model =
    let
        storedData =
            model.storedData

        storedData_ =
            { storedData | brands = Success brands }

        model_ =
            { model
                | storedData = storedData_
                , lastAction = None
            }
    in
        case model.route of
            Brands _ ->
                ( { model_ | route = Brands <| Success brands }, Cmd.none )

            _ ->
                ( model_, Cmd.none )


delete : Uuid -> Model -> ( Model, Cmd Msg )
delete brandId model =
    let
        model_ =
            { model | lastAction = BrandAction Delete }
    in
        ( model_, Brand.deleteBrand brandId )
