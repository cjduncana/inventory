module Views.Brand exposing (view)

import Html exposing (Html)
import Material.List
import Model exposing (Msg(Mdl))
import Models.Brand exposing (Brand)


view : Maybe (List Brand) -> Html Msg
view maybeBrands =
    Html.div []
        [ listBrands <| Maybe.withDefault [] maybeBrands ]


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
