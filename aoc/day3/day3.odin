package day3

import "core:fmt"
import "core:strings"
import "core:unicode"
import "core:strconv"

flood_get_num :: proc(s: string, i: int) -> (parsed: int, pos: int) {
    if !unicode.is_digit(rune(s[i])) do return -99999, -1

    pos = strings.last_index_proc(s[:i+1], proc(r:rune)->bool{return !unicode.is_digit(r)})
    pos += 1

    ok: bool
    parsed, ok = strconv.parse_int(s[pos:])

    return parsed, pos
}

p1 :: proc(input: []string) {
    // wow what a gnarly type
    foundNumSet := make(map[[2]int]struct{})
    defer delete(foundNumSet)

    total := 0

    for y in 0..<len(input) {
        for x in 0..<len(input[y]) {
            if input[y][x] != '.' &&
                !unicode.is_digit(rune(input[y][x])) {

                for ay in max(0, y-1)..=min(len(input), y+1) {
                    for ax in max(0, x-1)..=min(len(input[ay]), x+1) {
                        parsed, pos := flood_get_num(input[ay], ax)

                        if pos != -1 && !({ay, pos} in foundNumSet) {
                            total += parsed
                            foundNumSet[{ay, pos}] = {}

                            fmt.printf("found %i at %i %i\n", parsed, pos, ay)
                        }
                    }
                }
            }
        }
    }

    fmt.println(total)
}

p2 :: proc(input: []string) {
    total := 0

    for y in 0..<len(input) {
        for x in 0..<len(input[y]) {
            if input[y][x] == '*' {
                foundNumSet := make(map[[2]int]int)
                defer delete(foundNumSet)


                for ay in max(0, y-1)..=min(len(input), y+1) {
                    for ax in max(0, x-1)..=min(len(input[ay]), x+1) {
                        parsed, pos := flood_get_num(input[ay], ax)

                        if pos != -1 && !({ay, pos} in foundNumSet) {
                            foundNumSet[{ay, pos}] = parsed
                        }
                    }
                }

                if len(foundNumSet) != 2 do continue

                ratio := 1
                for pos, num in foundNumSet {
                    ratio *= num
                }
                total += ratio
            }
        }
    }

    fmt.println(total)
}
