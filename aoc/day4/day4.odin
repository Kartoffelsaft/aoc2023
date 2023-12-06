package day4

import "core:fmt"
import "core:strings"
import "core:strconv"

p1 :: proc(input: []string) {
    total := 0

    for line in input {
        rest := strings.trim_left_space(line[len("Card"):])
        
        cardNumParseLen := -1;
        cardNum, cardNumOk := strconv.parse_int(rest, 10, &cardNumParseLen);
        rest = strings.trim_left_space(rest[cardNumParseLen+len(": "):])

        winning := make(map[int]struct{})
        defer delete(winning)

        for rest[0] != '|' {
            parsed := -1
            num, numOk := strconv.parse_int(rest, 10, &parsed)
            rest = rest[parsed:]
            rest = strings.trim_left_space(rest)

            //fmt.println(rest)

            winning[num] = {}
        }
        rest = strings.trim_left_space(rest[len("| "):])

        winMatches := 0
        for len(rest) > 0 {
            parsed := -1
            num, numOk := strconv.parse_int(rest, 10, &parsed)
            rest = rest[parsed:]
            rest = strings.trim_left_space(rest)
            
            if num in winning do winMatches += 1
        }

        total += 1<<uint(winMatches-1) if winMatches >= 1 else 0
    }

    fmt.println(total)
}

p2 :: proc(input: []string) {
    cardCount := make([]int, len(input))
    defer delete(cardCount)
    for i in 0..<len(cardCount) do cardCount[i] = 1

    for line in input {
        rest := strings.trim_left_space(line[len("Card"):])
        
        cardNumParseLen := -1;
        cardNum, cardNumOk := strconv.parse_int(rest, 10, &cardNumParseLen);
        rest = strings.trim_left_space(rest[cardNumParseLen+len(": "):])

        winning := make(map[int]struct{})
        defer delete(winning)

        for rest[0] != '|' {
            parsed := -1
            num, numOk := strconv.parse_int(rest, 10, &parsed)
            rest = rest[parsed:]
            rest = strings.trim_left_space(rest)

            //fmt.println(rest)

            winning[num] = {}
        }
        rest = strings.trim_left_space(rest[len("| "):])

        winMatches := 0
        for len(rest) > 0 {
            parsed := -1
            num, numOk := strconv.parse_int(rest, 10, &parsed)
            rest = rest[parsed:]
            rest = strings.trim_left_space(rest)
            
            if num in winning do winMatches += 1
        }

        for i in cardNum..<cardNum+winMatches {
            if i >= len(cardCount) do break

            cardCount[i] += cardCount[cardNum-1]
        }
    }

    total := 0
    for c in cardCount do total += c
    fmt.println(total)
}
