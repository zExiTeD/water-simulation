#version 460 core

uniform vec4 alphaColor;
in  vec3 attributeColor;

out vec4 FragColor;

void main() {
    FragColor = vec4(attributeColor * alphaColor.a, 1.0f);
}
