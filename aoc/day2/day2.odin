package day2

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode"

Round :: struct {
    red: int,
    green: int,
    blue: int,
}

parse_round :: proc(s: string) -> Round {
    ret: Round

    rest := s
    for {
        nextNumAt := strings.index_proc(rest, unicode.is_digit)
        if nextNumAt == -1 do break
        rest = rest[nextNumAt:]

        numlen: int
        num, ok := strconv.parse_int(rest, 10, &numlen)
        rest = rest[numlen+len(" "):]

        if rest[:3] == "red" {
            ret.red = num
        } else if rest[:4] == "blue" {
            ret.blue = num
        } else if rest[:5] == "green" {
            ret.green = num
        }
    }

    return ret
}

Game :: struct {
    id: int,
    rounds: [dynamic]Round,
}

parse_game :: proc(s: string) -> Game {
    ret: Game

    rest := s[len("Game "):]

    idOk: bool
    idLen: int
    ret.id, idOk = strconv.parse_int(rest, 10, &idLen)
    rest = rest[idLen+len(": "):]

    for len(rest) > 0 {
        endOfRound := strings.index_rune(rest, ';')
        if endOfRound == -1 do endOfRound = len(rest)

        append(&ret.rounds, parse_round(rest[:endOfRound]))
        rest = rest[min(endOfRound+1, len(rest)):]
    }

    return ret
}

is_game_possible :: proc(game: Game) -> bool {
    for round in game.rounds {
        if round.red   > 12 ||
           round.green > 13 ||
           round.blue  > 14 {
            return false
        }
    }
    return true
}

p1 :: proc(input: []string) {
    totalIds := 0

    for line in input {
        game := parse_game(line)
        defer delete(game.rounds)

        if is_game_possible(game) do totalIds += game.id
    }

    fmt.println(totalIds)
}

p2 :: proc(input: []string) {
    totalPower := 0

    for line in input {
        game := parse_game(line)
        defer delete(game.rounds)

        minRed   := 0
        minGreen := 0
        minBlue  := 0
        for round in game.rounds {
            minRed   = max(minRed  , round.red  )
            minGreen = max(minGreen, round.green)
            minBlue  = max(minBlue , round.blue )
        }

        totalPower += minRed * minGreen * minBlue
    }

    fmt.println(totalPower)
}
