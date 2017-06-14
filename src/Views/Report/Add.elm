module Views.Report.Add exposing (view)

import Array exposing (Array)
import Array.Extra as Array
import Dropdown exposing (State)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import List.Extra as List
import Material.Button as Button
import Material.Color as Color
import Material.Icon as Icon
import Material.Options as Options
import Material.Table as Table
import Maybe.Extra as Maybe
import Model exposing (Model)
import Models.Dropdown as Dropdown
import Models.Good as Good exposing (Goods)
import Models.Record as Record exposing (FormMsg, PotentialRecord, Msg)
import Result.Extra as Result
import Translation.Report as T
import Views.Utilities as ViewUtils


view : Model -> Array ( State, PotentialRecord ) -> Html Msg
view model tuples =
    let
        selectedGoods =
            Array.filterMap (Tuple.second >> .good) tuples
                |> Array.toList

        goods =
            model.storedData.goods
                |> List.filterNot (flip List.member selectedGoods)

        records =
            Array.map Tuple.second tuples
    in
        Table.table []
            [ Table.thead [] [ headers ]
            , tuples
                |> Array.indexedMap (body model goods)
                |> Array.push (saveSection model records)
                |> Array.toList
                |> Table.tbody []
            ]


headers : Html Msg
headers =
    Table.tr []
        [ Table.th [] [ Html.text T.goodHeader ]
        , Table.th [] [ Html.text T.brandHeader ]
        , Table.th [] [ Html.text T.marketsHeader ]
        , Table.th [] [ Html.text T.quantityStoredHeader ]
        , Table.th [] [ Html.text T.quantityUsedHeader ]
        , Table.th [] [ Html.text "" ]
        ]


saveSection : Model -> Array PotentialRecord -> Html Msg
saveSection model records =
    let
        records_ =
            Record.sanitizeRecords records
    in
        Table.tr []
            [ Table.td [] [ Html.text "" ]
            , Table.td [] [ Html.text "" ]
            , Table.td [] [ Html.text "" ]
            , Table.td [] [ Html.text "" ]
            , Table.td [] [ Html.text T.saveButton ]
            , Table.td []
                [ Button.render Record.Mdl
                    [ 2, 0 ]
                    model.mdl
                    [ Button.icon
                    , Button.colored
                    , Button.ripple
                    , Button.disabled
                        |> Options.when (Maybe.isNothing records_)
                    , records_
                        |> Maybe.map (Record.SaveForm >> Options.onClick)
                        |> Options.maybe
                    ]
                    [ Icon.i "save" ]
                ]
            ]


body : Model -> Goods -> Int -> ( State, PotentialRecord ) -> Html Msg
body model goods index ( state, data ) =
    let
        defaultText =
            Maybe.withDefault "" >> Html.text

        getBrandName =
            Good.getBrand
                >> Maybe.map .name
                >> Maybe.withDefault ""

        showGoodMarkets =
            Good.getMarkets
                >> List.map .name
                >> String.join ", "
    in
        Table.tr []
            [ Table.td []
                [ Dropdown.view (Dropdown.goodConfig index)
                    state
                    goods
                    data.good
                    |> Html.map
                        (Record.GoodDropdownMsg index
                            >> Record.FormUpdate
                        )
                ]
            , Table.td []
                [ data.good
                    |> Maybe.map getBrandName
                    |> defaultText
                ]
            , Table.td []
                [ data.good
                    |> Maybe.map showGoodMarkets
                    |> defaultText
                ]
            , Table.td []
                [ data.quantityStored
                    |> possibleNumberField (Record.QuantityStoredUpdate index)
                ]
            , Table.td []
                [ data.quantityUsed
                    |> possibleNumberField (Record.QuantityUsed index)
                ]
            , Table.td []
                [ Button.render Record.Mdl
                    [ 1, index ]
                    model.mdl
                    [ Button.icon
                    , Button.ripple
                    , Color.text Color.accent
                    , Record.DeleteRecord index
                        |> Record.FormUpdate
                        |> Options.onClick
                    ]
                    [ Icon.i "delete" ]
                ]
            ]


possibleNumberField : (String -> FormMsg) -> Result String Int -> Html Msg
possibleNumberField message =
    Result.unpack (errorNumberField message) (okNumberField message)


errorNumberField : (String -> FormMsg) -> String -> Html Msg
errorNumberField message value =
    [ Attr.style <|
        if String.isEmpty value then
            []
        else
            [ ( "outline", "none" )
            , ( "border-color", "red" )
            , ( "box-shadow", "0 0 10px red" )
            ]
    ]
        |> numberField message value


okNumberField : (String -> FormMsg) -> Int -> Html Msg
okNumberField message int =
    []
        |> numberField message (toString int)


numberField : (String -> FormMsg) -> String -> List (Attribute Msg) -> Html Msg
numberField message value attributes =
    Html.input
        ([ Attr.type_ "text"
         , Attr.value value
         , ViewUtils.onBlur (Record.FormUpdate << message)
         ]
            ++ attributes
        )
        []
