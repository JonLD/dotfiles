def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    let needle = ($parts | str join " ")

    let base = if ($needle | is-empty) {
        "."
    } else if ($needle | str ends-with "/") or ($needle | str ends-with "\\") {
        $needle
    } else {
        $needle | path dirname | if ($in | is-empty) { "." } else { $in }
    }

    let stem = if ($needle | is-empty) or ($needle | str ends-with "/") or ($needle | str ends-with "\\") {
        ""
    } else {
        $needle | path basename | str downcase
    }

    let fs_matches = try {
        ls $base
        | where type == dir
        | get name
        | where { |n| ($n | str downcase) | str starts-with $stem }
        | each { |n| if $base == "." { $n } else { $base | path join $n } }
    } catch { [] }

    let z_matches = try {
        zoxide query --list --exclude $env.PWD -- ...$parts
        | lines
        | uniq
    } catch { [] }

    {
        options: {
            sort: false
            completion_algorithm: substring
            case_sensitive: false
        }
        completions: ($fs_matches | append $z_matches | uniq)
    }
}

def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
    __zoxide_z ...$rest
}
