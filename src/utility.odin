package main

import glfw "vendor:glfw"
import opengl "vendor:OpenGL"

frameBufferSizeCallback :: proc "c" ( window : glfw.WindowHandle , width ,height : i32 ) {
	opengl.Viewport(0 , 0 , width , height)
}
