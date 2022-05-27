

type camera
(**Camera object, has a set position, rotation, and field of view.*)

type position
 
type rotation

val set_camera : position -> rotation -> float -> camera
(**Set the position, rotation, and field of view of the camera.*)

val default_camera : camera
(**Creates camera object at point (0, 0, 0) and rotation (0, 0, 0) with FOV of 60 degrees.*)

val camposx : camera -> float
(**[camposx c] returns the x position of camera [c]*)

val camposy : camera -> float
(**[camposy c] returns the y position of camera [c]*)

val camposz : camera -> float
(**[camposz c] returns the z position of camera [c]*)

val camrotx : camera -> float
(**[camrotx c] returns the x rotation of camera [c]*)

val camroty : camera -> float
(**[camroty c] returns the y rotation of camera [c]*)

val camrotz : camera -> float
(**[camrotz c] returns the z rotation of camera [c]*)

val camfov : camera -> float
(**[camfov c] returns the field of view of camera [c]*)