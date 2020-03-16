module TableParserTests exposing (suite)

import Expect exposing (Expectation)
import Parser
import Parser.Advanced as Advanced exposing (..)
import Test exposing (..)


type alias Parser a =
    Advanced.Parser String Parser.Problem a


type alias Row =
    List String


parser =
    Parser.succeed
        (Table
            [ " abc ", " def " ]
            []
        )



{-

   | Col 1  | Col 2  | Col 3 |
   | ------ | ------ | ----- |
   | Cell 1 | Cell 2 |       |
-}


data =
    [ [ "Col 1", "Col 2", "Col 3" ]
    , [ "Cell 1", "Cell 2", "" ]
    ]


type Table
    = Table Row (List Row)


suite : Test
suite =
    describe "GFM tables"
        [ test "simple case" <|
            \() ->
                """| abc | def |
| --- | --- |
                """
                    |> Advanced.run parser
                    |> Expect.equal
                        (Ok
                            (Table
                                [ " abc ", " def " ]
                                []
                            )
                        )

        {-

           Possible strategies:
           * Do a second pass to validate it
           * During first pass, check

               TODO test case to fail parser immediately if there aren't enough
              | Col 1      | Col 2  | Col 3     |
              | ---------- | ------ |
              | **Cell 1** | Cell 2 | Extra col |
        -}
        ]


expectFail input =
    case Advanced.run parser input of
        Ok _ ->
            Expect.fail "Expected a parser error."

        Err _ ->
            Expect.pass
