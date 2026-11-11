#version 330
#extension GL_ARB_separate_shader_objects : require

#include <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

layout(location = 0) in vec2 texCoord0;
layout(location = 1) in vec4 vertexColor;

layout(location = 0) out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor;

    if (color.a < 0.01) {
        discard;
    }

    float r = color.r;
    float g = color.g;
    float b = color.b;

    // Отсекает серую заливку кнопки и тёмные пиксели её текстурного края
    bool isButtonTexture = (abs(r - g) < 0.15 && abs(g - b) < 0.15 && abs(r - b) < 0.15 && r < 0.85);

    if (isButtonTexture) {
        discard;
    }

    fragColor = color * ColorModulator;
}