type position 
(** x, y, and z position components of some object*)

type rotation
(** x, y, and z rotation components of some object*)

val make_pos : float -> float -> float -> position
(**[make_pos x y z] Creates position value *)

val make_rot : float -> float -> float -> rotation
(**[make_rot x y z] Creates rotation value *)

val start_window : string -> unit
(**[start_window s] opens a window with valid bodies from json file [s] loaded.*)