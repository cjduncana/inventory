module Models.Snackbar exposing (..)

import Material.Snackbar as Snackbar
import Models.Brand exposing (Brand)
import Models.Market exposing (Market)


type Payload
    = NoPayload
    | DeletedBrand Brand
    | DeletedMarket Market


type alias Msg =
    Snackbar.Msg Payload


type alias Model =
    Snackbar.Model Payload


init : Model
init =
    Snackbar.model
