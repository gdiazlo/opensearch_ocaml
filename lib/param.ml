type t = (string * string) list

let empty = []
let with_param k v params = (k, v) :: params
let remove_param k params = List.filter (fun p -> not (String.equal k p)) params
let bool_to_string b = if b then "true" else "fasle"
let float_to_string f = Format.sprintf "%10f" f
let int_to_string i = Format.sprintf "%d" i

exception ParamTypeNotSupported of string
