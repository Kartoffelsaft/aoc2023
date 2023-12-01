package day1

import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode"

p1 :: proc(input: []string) {
    total := 0

    for line in input {
        firstNum := line[strings.index_proc(line, unicode.is_digit):][:1]
        lastNum := line[strings.last_index_proc(line, unicode.is_digit):][:1]

        calibrationValue := strings.concatenate({firstNum, lastNum})
        defer delete(calibrationValue)

        num, ok := strconv.parse_int(calibrationValue)
        
        total += num
    }

    // daggonit thought it was the whole numbers
    /*
    for line in input {
        firstNum := line

        fFrom := strings.index_proc(firstNum, unicode.is_digit)
        firstNum = firstNum[fFrom:]

        fTo := strings.index_proc(firstNum, proc(r:rune)->bool {return !unicode.is_digit(r)})
        if fTo == -1 do fTo = len(firstNum)
        firstNum = firstNum[:fTo]


        lastNum := line
        lastNum = lastNum[:strings.last_index_proc(lastNum, unicode.is_digit)+1]
        lastNum = lastNum[strings.last_index_proc(lastNum, proc(r:rune)->bool {return !unicode.is_digit(r)})+1:]

        calibrationValue := strings.concatenate({firstNum, lastNum})
        defer delete(calibrationValue)

        num, ok := strconv.parse_int(calibrationValue, 10)
        if !ok {
            fmt.eprintf("%s could not be parsed from %s", calibrationValue, line)
            return
        }

        total += num;

        fmt.printf("%i \t%i \t%s \t%s \t%s\n", total, num, firstNum, lastNum, line)
    }
    */

    fmt.println(total)
}

p2 :: proc(input: []string) {
    parse_wordable :: proc(s: string) -> int {
        if len(s) == 1 {
            num, ok := strconv.parse_int(s)
            return num
        } else do switch s {
            case "one"  : return 1
            case "two"  : return 2
            case "three": return 3
            case "four" : return 4
            case "five" : return 5
            case "six"  : return 6
            case "seven": return 7
            case "eight": return 8
            case "nine" : return 9
        }

        return -1
    }

    total := 0

    for line in input {
        firstNumI, firstNumW := strings.index_multi(line, {
            "one"  , "1",
            "two"  , "2",
            "three", "3",
            "four" , "4",
            "five" , "5",
            "six"  , "6",
            "seven", "7",
            "eight", "8",
            "nine" , "9",
        })
        firstNum := line[firstNumI:][:firstNumW]

        
        // last_index_multi doesn't seem to exist, doing this as backup
        lastNumI, lastNumW := -1, -1
        for {
            nLastNumI, nLastNumW := strings.index_multi(line[lastNumI+1:], {
                "one"  , "1",
                "two"  , "2",
                "three", "3",
                "four" , "4",
                "five" , "5",
                "six"  , "6",
                "seven", "7",
                "eight", "8",
                "nine" , "9",
            })

            if nLastNumI == -1 do break

            lastNumI += nLastNumI+1
            lastNumW  = nLastNumW
        }
        lastNum := line[lastNumI:][:lastNumW]

        total += parse_wordable(firstNum)*10 + parse_wordable(lastNum)

        fmt.printf("%i \t%s \t%s \t%s\n", total, firstNum, lastNum, line)
    }

    fmt.println(total)
}
