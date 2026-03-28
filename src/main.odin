package main

import opengl "vendor:OpenGL"
import glfw "vendor:glfw"

import "core:fmt"

vertexShaderSource := `
#version 460 core
layout (location = 0) in vec3 aPos;
void main()
{
   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);
}
`

fragmentShaderSource := `
#version 460 core
out vec4 FragColor;

void main()
{
    FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);
}
`

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
		-0.5, -0.5 , 0,
		 0.5, -0.5 , 0,
		 0	,  0.5 , 0
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
	// ReCheck
	opengl.BufferData(
	 opengl.ARRAY_BUFFER,
	 len(vertexData) * size_of(f32),
	 rawptr(&vertexData[0]),
	 opengl.STATIC_DRAW
	)
	opengl.BindBuffer( opengl.ELEMENT_ARRAY_BUFFER,elementBufferObject )
	opengl.BufferData(
		opengl.ELEMENT_ARRAY_BUFFER,
	 	len(indices) * size_of( u32 ),
		rawptr( &indices[0] ),
	 	opengl.STATIC_DRAW
	);


	opengl.VertexAttribPointer(
		0,
		3,
		opengl.FLOAT,
		opengl.FALSE,
		3 * size_of(f32),
		0
	)

	opengl.EnableVertexAttribArray(0)

	opengl.BindVertexArray(0)


	vertexShader ,fragmentShader :u32
	result : bool

	vertexShader 	, result = compileShader( .VERTEX_SHADER , vertexShaderSource)
	fragmentShader 	, result = compileShader( .FRAGMENT_SHADER, fragmentShaderSource)
	defer opengl.DeleteShader( vertexShader   )
	defer opengl.DeleteShader( fragmentShader )

	shaderProgram := opengl.CreateProgram()
	opengl.AttachShader( shaderProgram, vertexShader)
	opengl.AttachShader( shaderProgram, fragmentShader)
	opengl.LinkProgram( shaderProgram )
	opengl.UseProgram( shaderProgram )
	defer opengl.DeleteProgram( shaderProgram )


	for (!glfw.WindowShouldClose(WindowHandle)) {

		if( glfw.GetKey(WindowHandle, glfw.KEY_ESCAPE) == glfw.PRESS ) {
			glfw.SetWindowShouldClose( WindowHandle, true)
		}

  		opengl.ClearColor(0.1, 0.1, 0.1, 1.0)
    	opengl.Clear(opengl.COLOR_BUFFER_BIT)

		opengl.UseProgram( shaderProgram )
		opengl.BindVertexArray( vertexArrayObjects )

		opengl.DrawElements( opengl.TRIANGLES,3,opengl.UNSIGNED_INT, rawptr( uintptr(0) ))

		glfw.SwapBuffers(WindowHandle)
		glfw.PollEvents()
	}

	glfw.Terminate()
}
