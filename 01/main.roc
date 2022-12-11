app "aoc1"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.3/5SXwdW7rH8QAOnD71IkHcFxCmBEPtFSLAIkclPEgjHQ.tar.br" }
    imports [
        pf.Stdout,
        pf.Task,
        pf.File,
        pf.Path,
    ]
    provides [main] to pf

main =
    path = Path.fromStr "input.txt"
    task =
        result <- File.readUtf8 path |> Task.await
        result
        |> parse
        |>

        # part 1
        # findMax

        # part 2
        findTopThree

    Task.attempt task \res ->
        when res is
            Ok _ -> Task.succeed {}
            Err _ -> Stdout.line "Sorry, error..."

parse = \result ->
    Str.split result "\n"
    |> List.walk { currentsublist: [], sublists: [], killme: "string" } \state, elem ->
        if elem == "" then
            { state & sublists: List.append state.sublists state.currentsublist, currentsublist: [] }
        else
            { state & currentsublist: List.append state.currentsublist elem }
    |> .sublists
    |> List.map (\list -> List.map list \e -> Result.withDefault (Str.toNat e) 0)

findMax = \list ->
    List.map list (\l -> List.sum l)
    |> List.max
    |> Result.withDefault 0
    |> Num.toStr
    |> Stdout.line

findTopThree = \list ->
    sortedList =
        List.map list (\l -> List.sum l)
        |> List.sortDesc

    sum =
        when sortedList is
            [a, b, c, ..] -> a + b + c
            _ -> 0

    sum
    |> Num.toStr
    |> Stdout.line
