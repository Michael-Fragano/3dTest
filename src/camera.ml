
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

type camera = {
  pos : position;
  rot : rotation;
  fov : float
}

let set_camera p r f : camera=
  {
    pos = p;
    rot = r;
    fov = f
  }

let set_all_camera x y z xr yr zr f : camera =
  {
    pos = {x = x; y = y; z = z};
    rot = {x = xr; y = yr; z = zr};
    fov = f
  }

(**Rotation (0, 0, 0) faces the camera in the +y direction*)
let default_camera : camera =
  {
    pos = {x = 0.; y = 0.; z = 0.};
    rot = {x = 0.; y = 0.; z = 0.};
    fov = 1.0472
  }

  let camposx cam : float = cam.pos.x
  let camposy cam : float = cam.pos.y
  let camposz cam : float = cam.pos.z

  let camrotx cam : float = cam.rot.x

  let camroty cam : float = cam.rot.y
  let camrotz cam : float = cam.rot.z

  let camfov cam : float = cam.fov
