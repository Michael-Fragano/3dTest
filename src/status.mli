type input_state =
  | Idle
  | Pressed
  | Held
  | Released
  | Unmonitored

  type t

val default : unit -> t
(** [default ()] returns a status with the default values*)

val update_input : bool -> input_state -> input_state
(** [update_input is_down curr] outputs the new input state based on if
    [is_down ()] returns true or false*)


val keys_down : unit -> char list
(** returns a list of keys which are down this frame*)


val poll_input : t -> t
(** updates the key states based on which keys are down*)

val key_state : char -> t -> input_state
(** [key_state c status] returns the current state of the key [c]*)

val bind_key : char -> input_state -> (t -> t) -> t -> t
(** [bind_mouse c state f status] returns [f status] if [state] matches
    [key_state c status]. Otherwise returns [status] *)