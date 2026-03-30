package main

import opengl "vendor:OpenGL"
import glfw "vendor:glfw"

frameBufferSizeCallback :: proc "c" (window: glfw.WindowHandle, width, height: i32) {
	opengl.Viewport(0, 0, width, height)
}

compileShader :: proc(shaderType: opengl.Shader_Type, shaderSource: string) -> (u32, bool) {
	shaderID := opengl.CreateShader(cast(u32)shaderType)
	shaderSourceLength: i32 = cast(i32)len(shaderSource)

	shaderSource_cstring := cast(cstring)raw_data(shaderSource)

	opengl.ShaderSource(shaderID, 1, &shaderSource_cstring, &shaderSourceLength)

	opengl.CompileShader(shaderID)
	return shaderID, true
}

createShaderProgram :: proc(vertexShaderSource, fragmentShaderSource: string) -> u32 {
	vertexShader,_	 := compileShader(.VERTEX_SHADER, vertexShaderSource)
	fragmentShader,_ := compileShader(.FRAGMENT_SHADER, fragmentShaderSource)

	defer opengl.DeleteShader(vertexShader)
	defer opengl.DeleteShader(fragmentShader)

	shaderProgram := opengl.CreateProgram()
	opengl.AttachShader(shaderProgram, vertexShader)
	opengl.AttachShader(shaderProgram, fragmentShader)
	opengl.LinkProgram(shaderProgram)

	return shaderProgram
}
