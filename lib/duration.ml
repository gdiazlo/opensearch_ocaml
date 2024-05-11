type t = int

let nanosecond = 1
let microsecond = 1000 * nanosecond
let millisecond = 1000 * microsecond
let second = 1000 * millisecond
let minute = 60 * second
let hour = 60 * minute
let in_s i = i * second
let in_ms i = i * millisecond
let in_us i = i * microsecond
let in_ns i = i * nanosecond

let to_string (d : t) =
  if d < millisecond
  then Format.sprintf "%10dnanos" d
  else Format.sprintf "%10dms" (in_ms d)
;;
