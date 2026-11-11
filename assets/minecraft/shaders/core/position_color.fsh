#version 330
#extension GL_ARB_separate_shader_objects : require

layout(location = 0) in vec4 vertexColor;

layout(location = 0) out vec4 fragColor;

void main() {
    // Удаляет чёрные/тёмные линии обводки и фокуса кнопок
    if (vertexColor.r < 0.15 && vertexColor.g < 0.15 && vertexColor.b < 0.15 && vertexColor.a > 0.5) {
        discard;
    }

    fragColor = vertexColor;
}