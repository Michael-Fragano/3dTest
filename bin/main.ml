(**Test?*)
let rec run () =
  print_endline "What models do you want to visualize? Type 'Q' to quit.\n";
  let file = read_line() in
  if file = "Q" then (print_endline "Thanks for visiting!\n")
  else
    try Visual.Render.start_window file; 
    run()
  with Sys_error str ->
    print_endline "\n\
    ~~Sorry, we couldn't find a file with that name. \
    Please try again!\n";
    run()
in

run()