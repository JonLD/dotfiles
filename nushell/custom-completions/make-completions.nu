def "nu-complete make targets" [] {
    let makefile = if ("Makefile" | path exists) {
        "Makefile"
    } else if ("makefile" | path exists) {
        "makefile"
    } else {
        return []
    }

    let make_cmd = if (sys host | get name) == "Windows" { "mingw32-make" } else { "make" }
    do { ^$make_cmd -pRrq : } | complete | get stdout
    | lines
    | where { |line| $line =~ '^[a-zA-Z_][a-zA-Z0-9_-]*:' and not ($line =~ '^[a-zA-Z_][a-zA-Z0-9_-]*:%') }
    | each { |line| $line | split row ':' | first | str trim }
    | where { |t| not ($t | str starts-with '.') }
    | uniq
    | sort
}

export extern "make" [
    target?: string@"nu-complete make targets"
    --file (-f): string
    --jobs (-j): int
    --keep-going (-k)
    --directory (-C): string
    --dry-run (-n)
    --always-make (-B)
    ...rest: string
]

export extern "mingw32-make" [
    target?: string@"nu-complete make targets"
    --file (-f): string
    --jobs (-j): int
    --keep-going (-k)
    --directory (-C): string
    --dry-run (-n)
    --always-make (-B)
    ...rest: string
]