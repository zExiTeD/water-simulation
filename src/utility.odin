package main

import glfw "vendor:glfw"
import opengl "vendor:OpenGL"

frameBufferSizeCallback :: proc "c" ( window : glfw.WindowHandle , width ,height : i32 ) {
	opengl.Viewport(0 , 0 , width , height)
}

compileShader ::proc( shaderType : opengl.Shader_Type, shaderSource : string) -> (u32,bool) {
	shaderID := opengl.CreateShader( cast(u32) shaderType )
	shaderSourceLength : i32 = cast(i32) len( shaderSource )

	shaderSource_cstring := cast(cstring) raw_data( shaderSource )

	opengl.ShaderSource(
		shaderID,
		1,
		&shaderSource_cstring,
		&shaderSourceLength
	)

	opengl.CompileShader( shaderID )
	return shaderID , true
}
