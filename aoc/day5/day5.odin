package day5

import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"

Range :: struct {
    dest: int,
    src: int,
    range: int,
}

Mapper :: struct {
    ranges: []Range,
}

parse_range :: proc(s: string) -> (ret: Range) {
    rest := s

    parseLen := -1

    destOk: bool
    ret.dest, destOk = strconv.parse_int(rest, 10, &parseLen)
    rest = strings.trim_left_space(rest[parseLen:])

    srcOk: bool
    ret.src, srcOk = strconv.parse_int(rest, 10, &parseLen)
    rest = strings.trim_left_space(rest[parseLen:])

    rangeOk: bool
    ret.range, rangeOk = strconv.parse_int(rest, 10, &parseLen)

    return
}

parse_mapper :: proc(ss: []string) -> (ret: Mapper) {
    ret.ranges = make([]Range, len(ss)-1)
    for s, i in ss[1:] {
        ret.ranges[i] = parse_range(s)
    }

    return
}

parse_mappers :: proc(ss: []string) -> []Mapper {
    mapsStr := make([dynamic][]string)
    defer delete(mapsStr)

    restOfLines := ss
    isLineEmpty :: proc(s: string)->bool {return len(s)==0}

    for i, found := slice.linear_search_proc(restOfLines, isLineEmpty); 
        found; 
        i, found  = slice.linear_search_proc(restOfLines, isLineEmpty) {
        
        append(&mapsStr, restOfLines[:i])
        restOfLines = restOfLines[i+1:]
    }
    append(&mapsStr, restOfLines[:])

    return slice.mapper(mapsStr[1:], parse_mapper)
}

apply_mapper :: proc(mapper: Mapper, num: int) -> int {
    for r in mapper.ranges {
        if num >= r.src && num - r.src < r.range do return num - r.src + r.dest
    }

    return num
}

p1 :: proc(input: []string) {
    maps := parse_mappers(input)
    defer {
        for m in maps do delete(m.ranges)
        delete(maps)
    }

    restSeeds := input[0][len("seeds: "):]
    min := 0x7fffffff

    for len(restSeeds) > 0 {
        seedLen := -1
        seed, seedOk := strconv.parse_int(restSeeds, 10, &seedLen)
        restSeeds = strings.trim_left_space(restSeeds[seedLen:])

        fmt.print(seed)
        for m in maps {
            seed = apply_mapper(m, seed)
            fmt.print(" ->", seed)
        }
        fmt.println()

        if seed < min do min = seed
    }

    fmt.println(min)
}

apply_mapper_reverse :: proc(mapper: Mapper, num: int) -> int {
    for r in mapper.ranges {
        if num >= r.dest && num - r.dest < r.range do return num - r.dest + r.src
    }

    return num
}

p2 :: proc(input: []string) {
    SeedRange :: struct {
        start: int,
        len: int,
    }

    seeds := make([dynamic]SeedRange)
    restSeeds := input[0][len("seeds: "):]

    for len(restSeeds) > 0 {
        seedLen := -1
        seedS, seedSOk := strconv.parse_int(restSeeds, 10, &seedLen)
        restSeeds = strings.trim_left_space(restSeeds[seedLen:])

        seedL, seedLOk := strconv.parse_int(restSeeds, 10, &seedLen)
        restSeeds = strings.trim_left_space(restSeeds[seedLen:])

        append(&seeds, SeedRange{seedS, seedL})
    }

    maps := parse_mappers(input)
    defer {
        for m in maps do delete(m.ranges)
        delete(maps)
    }

    for i := 0; true; i += 1 {
        rseed := i
        #reverse for m in maps {
            rseed = apply_mapper_reverse(m, rseed)
        }

        found := false
        for sr in seeds {
            if rseed >= sr.start && rseed < sr.start + sr.len {
                found = true
                break
            }
        }
        if found {
            fmt.println(i)
            break
        }
    }
}
