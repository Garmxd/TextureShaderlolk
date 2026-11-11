#version 330

#extension GL_ARB_separate_shader_objects : require
#include <minecraft:globals.glsl>

uniform sampler2D InSampler;
uniform sampler2D OverlaySampler;

layout(location = 0) in vec2 texCoord;
layout(location = 0) out vec4 fragColor;

layout(std140) uniform SamplerInfo {
    vec2 OutSize;
    vec2 InSize;
};

layout(std140) uniform OverlayConfig {
    float Opacity;
};

void main() {
    vec4 screen = texture(InSampler, texCoord);
    vec4 overlay = texture(OverlaySampler, texCoord);

    // Alpha blend: overlay on top of screen, controlled by Opacity
    float a = overlay.a * Opacity;
    vec3 result = mix(screen.rgb, overlay.rgb, a);

    fragColor = vec4(result, 1.0);
}
