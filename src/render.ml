open Graphics
open Yojson.Basic.Util
open Camera
open Status

type position = {
  x : float;
  y : float;
  z : float;
}

type rotation = {
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
  pos : position;
  rot : rotation;
  points : point list;
  lines : line list;
}

type bodies = {
  bods : body list}

 (**Start of json functions*) 
  let pos_json p : position =
    match p with
    | [ h; m; t ] -> { x = to_float h; y = to_float m; z = to_float t }
    | _ -> raise (Failure "Does not contain three floats")
  
  let rot_json r : rotation = 
    match r with
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
    pos = pos_json (to_list (member "position" j));
    rot = rot_json (to_list (member "rotation" j));
    points = List.map point_json  (to_list (member "points" j));
    lines = List.map line_json  (to_list (member "lines" j));
  }
  let from_json json =
  {
    bods = List.map body_json (to_list (member "bodies" json))
  }

  (**End of json functions*)  

let make_pos x y z : position = 
  {
    x = x;
    y = y;
    z = z
  }

  let make_rot x y z : rotation = 
    {
      x = x;
      y = y;
      z = z
    }

let init () =
  open_graph " 800x800";
  set_window_title "3D Render Testing";
  auto_synchronize false



let rel_pos (camera : Camera.camera) (pos : position) (body : body) = (
  let cosx = cos body.rot.x in
  let sinx = sin body.rot.x in
  let cosy = cos body.rot.y in
  let siny = sin body.rot.y in
  let cosz = cos body.rot.z in
  let sinz = sin body.rot.z in

  let ccosx = cos (-.camrotx camera) in
  let csinx = sin (-.camrotx camera) in
  let ccosy = cos (-.camroty camera) in
  let csiny = sin(-.camroty camera) in
  let ccosz = cos (-.camrotz camera) in
  let csinz = sin (-.camrotz camera) in

  (**handle body rotation*)
  let rotx = {x = pos.x; y = pos.y *. cosx -. pos.z *. sinx ; z = pos.z *. cosx +. pos.y *. sinx} in
  let roty = {x = rotx.x *. cosy -. rotx.z *. siny; y = rotx.y; z = rotx.z *. cosy +. rotx.x *. siny} in
  let rotz = {x = roty.x *. cosz -. roty.y *. sinz; y = roty.y *. cosz +. roty.x *. sinz; z = roty.z} in

  (**Find global position*)
  let pos1 = { x = (rotz.x +. body.pos.x); y = (rotz.y +. body.pos.y); z = (rotz.z +. body.pos.z)} in

  (**Find position relative to camera's global positioin*)
  let cpos = {x = (pos1.x -. camposx camera); y = (pos1.y -. camposy camera); z = (pos1.z -. camposz camera)} in

  (**Find position relative to camera's rotation*)
  let crotx = {x = cpos.x; y = cpos.y *. ccosx -. cpos.z *. csinx ; z = cpos.z *. ccosx +. cpos.y *. csinx} in
  let croty = {x = crotx.x *. ccosy -. crotx.z *. csiny; y = crotx.y; z = crotx.z *. ccosy +. crotx.x *. csiny} in
  {x = croty.x *. ccosz -. croty.y *. csinz; y = croty.y *. ccosz +. croty.x *. csinz; z = croty.z}
)


let rec draw_points camera (points: point list) body= (
  match points with
  | [] -> ()
  | h :: t -> 
    let maxr = (camfov camera /. 2.) in
    let rpos = rel_pos camera h.pos body in
    let y = atan (rpos.z /. rpos.y) in
    let x = atan (rpos.x/. rpos.y) in
    if (y > maxr) || (x > maxr) then
    draw_points camera t body
    else 
    fill_circle (int_of_float ((400. *.  (x /. maxr)) +. 400.)) (int_of_float ((400. *.  (y /. maxr)) +. 400.)) 3;
    draw_points camera t body
)

let rec draw_lines camera (lines : line list) body = (
  match lines with
  | [] -> ()
  | h :: t -> 
    let maxr = (camfov camera /. 2.) in
    let arpos = rel_pos camera h.a body in
    let ay = atan (arpos.z /. arpos.y) in
    let ax = atan (arpos.x/. arpos.y) in

    let brpos = rel_pos camera h.b body in
    let by = atan (brpos.z /. brpos.y) in
    let bx = atan (brpos.x/. brpos.y) in
    (**TODO: Add way to check if no part of a line crosses camera, and skip drawing it.*)
    draw_poly_line [|
      ((int_of_float ((400. *.  (ax /. maxr)) +. 400.)), (int_of_float ((400. *.  (ay /. maxr)) +. 400.)));
      ((int_of_float ((400. *.  (bx /. maxr)) +. 400.)), (int_of_float ((400. *.  (by /. maxr)) +. 400.)));
    |];
    draw_lines camera t body
)

let rec draw_bodies camera clear = function
  | [] -> ()
  | h :: t -> 
    if clear then set_color background
    else set_color (0x000000);
    draw_points camera h.points h;
    draw_lines camera h.lines h;
    draw_bodies camera clear t


let render bodies camera =
  draw_bodies camera false bodies.bods;
  synchronize ();
  draw_bodies camera true bodies.bods

let update_cam cam status : camera = 
  if (key_state 'a' status = Pressed) || (key_state 'a' status = Held)  then (set_all_camera (camposx cam -. 5.) (camposy cam) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state 'd' status = Pressed) || (key_state 'd' status = Held)  then (set_all_camera (camposx cam +. 5.) (camposy cam) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state 'w' status = Pressed) || (key_state 'w' status = Held)  then (set_all_camera (camposx cam) (camposy cam +. 5.) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state 's' status = Pressed) || (key_state 's' status = Held)  then (set_all_camera (camposx cam) (camposy cam -. 5.) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state ' ' status = Pressed) || (key_state ' ' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam +. 5.) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state 'z' status = Pressed) || (key_state 'z' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam -. 5.) (camrotx cam) (camroty cam) (camrotz cam) (camfov cam))
  else if (key_state 'j' status = Pressed) || (key_state 'j' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam +. 0.03) (camfov cam))
  else if (key_state 'l' status = Pressed) || (key_state 'l' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam) (camroty cam) (camrotz cam -. 0.03) (camfov cam))
  else if (key_state 'i' status = Pressed) || (key_state 'i' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam +. 0.03) (camroty cam) (camrotz cam ) (camfov cam))
  else if (key_state 'k' status = Pressed) || (key_state 'k' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam -. 0.03) (camroty cam) (camrotz cam ) (camfov cam))
  else if (key_state 'u' status = Pressed) || (key_state 'u' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam) (camroty cam +. 0.03) (camrotz cam ) (camfov cam))
  else if (key_state 'o' status = Pressed) || (key_state 'o' status = Held)  then (set_all_camera (camposx cam) (camposy cam ) (camposz cam) (camrotx cam) (camroty cam -. 0.03) (camrotz cam ) (camfov cam))
  
  else cam

let rec main_loop bodies time (camera: Camera.camera) status =
  render bodies camera;
  let new_camera = update_cam camera status in 
  let new_status = poll_input status in
  let new_time = Unix.gettimeofday () in
  let time_left = (1. /. 60.) -. new_time +. time in
  if time_left > 0. then Unix.sleepf time_left;
  main_loop bodies (new_time +. time_left) new_camera new_status


let start_window json =
  let bodies =
    "data/" ^ json ^ ".json"
    |> Yojson.Basic.from_file |> from_json in
  try
  init();
  (main_loop bodies (Unix.gettimeofday ()) Camera.default_camera ) (Status.default ())
with Graphics.Graphic_failure _ -> Graphics.close_graph ()