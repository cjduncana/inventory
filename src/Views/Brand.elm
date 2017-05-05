module Views.Brand exposing (view)

import Html exposing (Html)
import Material.List
import Model exposing (Msg(Mdl))
import Models.Brand exposing (Brand)
import RemoteData exposing (RemoteData(..))
import Routing.Error exposing (Error)


view : RemoteData Error (List Brand) -> Html Msg
view possibleBrands =
    case possibleBrands of
        NotAsked ->
            Html.text "Brands not asked yet"

        Loading ->
            Html.text "Brands being loaded"

        Failure _ ->
            Html.text "An error has occurred"

        Success brands ->
            listBrands brands


listBrands : List Brand -> Html Msg
listBrands brands =
    if List.isEmpty brands then
        Html.text "No brands yet"
    else
        Material.List.ul [] <|
            List.map brandListItem brands


brandListItem : Brand -> Html Msg
brandListItem brand =
    Material.List.li [] [ Html.text brand.name ]
