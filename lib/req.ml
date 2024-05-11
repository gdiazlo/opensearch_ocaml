type meth =
  [ `GET
  | `POST
  | `PUT
  | `DELETE
  | `HEAD
  ]

type t =
  { meth : meth
  ; path : string
  ; params : (string * string) list
  }

let new_req meth path params = { meth; path; params }

let pp_meth fmt = function
  | `GET -> Format.fprintf fmt "GET"
  | `POST -> Format.fprintf fmt "POST"
  | `PUT -> Format.fprintf fmt "PUT"
  | `DELETE -> Format.fprintf fmt "DELETE"
  | `HEAD -> Format.fprintf fmt "HEAD"
;;

let req_pp fmt req =
  Format.fprintf
    fmt
    "@[<hov 2>(req @;<1 2>(meth = %a)@;<1 2>(path = %s))@]"
    pp_meth
    req.meth
    req.path
;;
