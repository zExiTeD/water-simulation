package main

import opengl "vendor:OpenGL"
import glfw "vendor:glfw"
import "core:math"

vertexShaderSource := #load( "shaders/vertexShader.glsl", string)
fragmentShaderSource := #load( "shaders/fragmentShader.glsl", string)


main :: proc() {
	glfw.Init()
	glfw.WindowHint(glfw.CONTEXT_VERSION_MAJOR, 4)
	glfw.WindowHint(glfw.CONTEXT_VERSION_MINOR, 6)
	glfw.WindowHint(glfw.OPENGL_PROFILE, glfw.OPENGL_CORE_PROFILE)

	WindowHandle := glfw.CreateWindow(800, 600, "Hello Window", nil, nil)
	glfw.MakeContextCurrent(WindowHandle)
	glfw.SetFramebufferSizeCallback(WindowHandle, frameBufferSizeCallback)

	opengl.load_up_to(4, 6, glfw.gl_set_proc_address)

	vertexData : []f32 = {
		-0.5, -0.5 , 0, 1, 0, 0,
		 0.5, -0.5 , 0, 0, 1, 0,
		 0	,  0.5 , 0, 0, 0, 1
	}

	indices	: []u32 = {
		0 , 1 , 2
	}


	vertexArrayObjects : u32
	opengl.GenVertexArrays(1 , &vertexArrayObjects)
	vertexBufferObject : u32
	opengl.GenBuffers( 1, &vertexBufferObject)
	elementBufferObject : u32
	opengl.GenBuffers( 1, &elementBufferObject)

	opengl.BindVertexArray( vertexArrayObjects )

	opengl.BindBuffer( opengl.ARRAY_BUFFER, vertexBufferObject)
	opengl.BufferData(
	 opengl.ARRAY_BUFFER,
	 len(vertexData) * size_of(f32),
	 raw_data(vertexData),
	 opengl.STATIC_DRAW
	)

	opengl.BindBuffer( opengl.ELEMENT_ARRAY_BUFFER,elementBufferObject )
	opengl.BufferData(
		opengl.ELEMENT_ARRAY_BUFFER,
	 	len(indices) * size_of( u32 ),
		raw_data(indices),
	 	opengl.STATIC_DRAW
	);

	opengl.VertexAttribPointer(
		0,
		3,
		opengl.FLOAT,
		opengl.FALSE,
		6 * size_of(f32),
		0
	)
	opengl.EnableVertexAttribArray(0)
	opengl.VertexAttribPointer(
		1,
		3,
		opengl.FLOAT,
		opengl.FALSE,
		6 * size_of(f32),
		3 * size_of(f32)
	)
	opengl.EnableVertexAttribArray(1)


	opengl.BindVertexArray(0)

	opengl.BindBuffer( opengl.ARRAY_BUFFER, 0)
	opengl.BindBuffer( opengl.ELEMENT_ARRAY_BUFFER, 0 )


	shaderProgram := createShaderProgram( vertexShaderSource , fragmentShaderSource)
	defer opengl.DeleteProgram( shaderProgram )

	opengl.UseProgram( shaderProgram )
	opengl.BindVertexArray( vertexArrayObjects )

	for (!glfw.WindowShouldClose(WindowHandle)) {

		if( glfw.GetKey(WindowHandle, glfw.KEY_ESCAPE) == glfw.PRESS ) {
			glfw.SetWindowShouldClose( WindowHandle, true)
		}

  		opengl.ClearColor(0.1, 0.1, 0.1, 1.0)
    	opengl.Clear(opengl.COLOR_BUFFER_BIT)

     	alpha := ( math.sin( glfw.GetTime() ) / 2 ) + 0.5
        uniformLocation := opengl.GetUniformLocation( shaderProgram, "alphaColor")
        opengl.Uniform4f( uniformLocation, 1.0, 1, 1, cast(f32)alpha)


		opengl.DrawElements( opengl.TRIANGLES,3,opengl.UNSIGNED_INT, rawptr( uintptr(0) ))

		glfw.SwapBuffers(WindowHandle)
		glfw.PollEvents()
	}

	glfw.Terminate()
}
