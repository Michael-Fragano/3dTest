open Graphics
open Yojson.Basic.Util

type position = {
  x : float;
  y : float;
  z : float;
}

type point = {
  pos : position;
}

type line = {
  a : position;
  b : position;
}

type body = {
  points : point list;
  lines : line list;
}

type bodies = {
  bods : body list}

  let pos_json p : position =
    match p with
    | [ h; m; t ] -> { x = to_float h; y = to_float m; z = to_float t }
    | _ -> raise (Failure "Does not contain three floats")
  
let point_json  p ={
  pos = pos_json (to_list (member "point" p));
}

let line_json l = 

  let line = (to_list (member "line" l)) in
  match line with
  | [ a; b; c; d; e; f] -> {a = pos_json [a; b; c]; b = pos_json [d; e; f]}
  | _ -> raise (Failure "Does not contain six floats")

let body_json j =
  {
    points = List.map point_json  (to_list (member "points" j));
    lines = List.map line_json  (to_list (member "lines" j));
  }
  let from_json json =
  {
    bods = List.map body_json (to_list (member "bodies" json))
  }


let init () =
  open_graph " 1000x1000";
  set_window_title "3D Render Testing";
  auto_synchronize false

let render bodies =
  failwith "unimplemented"

let rec main_loop bodies time =
  render bodies;
  let new_time = Unix.gettimeofday () in
  let time_left = (1. /. 60.) -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  main_loop bodies (new_time +. time_left)


let start_window json =
  let bodies =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> from_json
  in
  try
  init();
  main_loop bodies (Unix.gettimeofday ())
with Graphics.Graphic_failure _ -> Graphics.close_graph ()