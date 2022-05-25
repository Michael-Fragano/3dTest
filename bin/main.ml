(**Test?*)
let rec run () =
  print_endline "What thing do you wanna visualize? Type 'Q' to quit.\n";
  let file = read_line() in
  if file = "Q" then (print_endline "Thanks for visiting!\n")
  else 
    (print_endline "renderer is currently unimplemented\n";
    run())
in

run()