module Updates.Error exposing (..)

import Model exposing (Model, Msg, Action(..))
import Models.Brand exposing (Action(..))
import Models.Error exposing (Error(..))
import RemoteData
import Routing.Routes as Routes


update : Error -> Model -> ( Model, Cmd Msg )
update error model =
    let
        model_ =
            { model | error = Just error }
    in
        case model.lastAction of
            None ->
                ( model_, Cmd.none )

            BrandAction action ->
                case action of
                    Get ->
                        let
                            brandError _ =
                                RemoteData.Failure error

                            route =
                                Routes.mapBrands brandError model.route

                            model__ =
                                { model_
                                    | route = route
                                    , lastAction = None
                                }
                        in
                            ( model__, Cmd.none )

                    _ ->
                        ( model_, Cmd.none )
