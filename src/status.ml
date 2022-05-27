type input_state =
  | Idle
  | Pressed
  | Held
  | Released
  | Unmonitored

type t = {
  key_states : (char * input_state) list;
}

let default () =
  {
    key_states =
      [
        ('w', Idle);
        ('a', Idle);
        ('s', Idle);
        ('d', Idle);
        (' ', Idle);
        ('z', Idle);
        ('i', Idle);
        ('j', Idle);
        ('k', Idle);
        ('l', Idle);
      ]
  }

  let update_input is_down = function
  | Idle -> if is_down then Pressed else Idle
  | Pressed -> if is_down then Held else Released
  | Held -> if is_down then Held else Released
  | Released | Unmonitored -> if is_down then Pressed else Idle

  let keys_down () =
    let keys = ref [] in
    let _ =
      while Graphics.key_pressed () do
        match Graphics.read_key () with
        | c -> keys := c :: !keys
      done
    in
    !keys

    let poll_input (status : t) : t =
      let keys = keys_down () in
      {
        key_states =
          List.map
            (fun (key, state) ->
              (key, update_input (List.mem key keys) state))
            status.key_states;
      }
    
      let key_state c status =
        match List.assoc_opt c status.key_states with
        | Some state -> state
        | None -> Unmonitored

        let bind_key key state f s = if key_state key s = state then f s else s
