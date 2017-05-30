module Updates.Snackbar exposing (update)

import Material.Snackbar as Snackbar exposing (Msg(Click, End))
import Model exposing (Model)
import Models.Brand as Brand
import Models.Good as Good
import Models.Market as Market
import Models.Snackbar
    exposing
        ( Payload
            ( DeletedBrand
            , DeletedGood
            , DeletedMarket
            )
        )


update : Models.Snackbar.Msg -> Model -> ( Model, Cmd Model.Msg )
update msg model =
    case msg of
        End payload ->
            destroy payload model

        Click payload ->
            restore payload model

        _ ->
            snackbar msg model


destroy : Payload -> Model -> ( Model, Cmd Model.Msg )
destroy payload model =
    case payload of
        DeletedBrand brand ->
            ( model, Brand.destroyBrand brand.uuid )

        DeletedGood good ->
            ( model, Good.destroyGood good.id )

        DeletedMarket market ->
            ( model, Market.destroyMarket market.uuid )

        _ ->
            ( model, Cmd.none )


restore : Payload -> Model -> ( Model, Cmd Model.Msg )
restore payload model =
    case payload of
        DeletedBrand brand ->
            ( model, Brand.restoreBrand brand.uuid )

        DeletedGood good ->
            ( model, Good.restoreGood good.id )

        DeletedMarket market ->
            ( model, Market.restoreMarket market.uuid )

        _ ->
            ( model, Cmd.none )


snackbar : Models.Snackbar.Msg -> Model -> ( Model, Cmd Model.Msg )
snackbar msg model =
    let
        ( snackbarModel, snackbarCommand ) =
            Snackbar.update msg model.snackbar

        model_ =
            { model | snackbar = snackbarModel }

        command_ =
            Cmd.map Model.SnackbarMsg snackbarCommand
    in
        ( model_, command_ )
