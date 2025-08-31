#version 330

in vec2 fragTexCoord;

uniform sampler2D texture0;
uniform vec4 colDiffuse;
uniform vec2 center;
uniform vec2 julia_center;
uniform float zoom;

out vec4 finalColor;

int MAX_ITER = 1000;

float mandelbrot(vec2 c) {
    vec2 z = c;
    int iterations = 0;
    for (; iterations < MAX_ITER; iterations++) {
        vec2 z2 = vec2(z.x * z.x - z.y * z.y, 2 * z.x * z.y);
        z = z2 + julia_center;

        if (length(z) > 2.0) {
            return float(iterations) / float(MAX_ITER);
        }
    }

    return 0.0f;
}

void main() {
    vec4 texelColor = texture(texture0, fragTexCoord);

    vec2 updated = (fragTexCoord * zoom - center);

    float m = mandelbrot(updated);

    vec3 color = mix(vec3(1.0, 0.0, 1.0), vec3(0.0, 0.0, 1.0), m) * float(m > 0.0f);

    finalColor = vec4(color, 1.0);
}
