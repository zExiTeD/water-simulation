package main

import opengl "vendor:OpenGL"
import glfw "vendor:glfw"

main :: proc() {
	glfw.Init()
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 3)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 3)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	WindowHandle := glfw.CreateWindow(800, 600, "Hello Window", nil, nil)
	glfw.MakeContextCurrent(WindowHandle)
	glfw.SetFramebufferSizeCallback(WindowHandle, frameBufferSizeCallback)

	opengl.load_up_to(4, 6, glfw.gl_set_proc_address)

	for (!glfw.WindowShouldClose(WindowHandle)) {

		if( glfw.GetKey(WindowHandle, glfw.KEY_ESCAPE) == glfw.PRESS ) {
			glfw.SetWindowShouldClose( WindowHandle, true)
		}

		opengl.ClearColor( 10 , 10 , 0 , 0)
		opengl.Clear( opengl.COLOR_BUFFER_BIT )

		glfw.SwapBuffers(WindowHandle)
		glfw.PollEvents()
	}

	glfw.Terminate()
}
