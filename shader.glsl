#version 330

in vec2 fragTexCoord;

uniform sampler2D texture0;
uniform vec4 colDiffuse;

out vec4 finalColor;

float mandelbrot(vec2 c) { 
	vec2 z = vec2(0.0f, 0.0f);
	int iterations = 0;
	for (; iterations < 1000; iterations++) {
		vec2 z2 = vec2(z.x * z.x - z.y * z.y, 2 * z.x * z.y);
		z = z2 + c;

		if (length(z) > 2.0) { 
			return 0.0; 
		}
	}

	if (iterations == 1000 - 1) { 
		return 0.0f;
    }

	return length(z);
}

void main() { 
	vec4 texelColor = texture(texture0, fragTexCoord);

	vec2 updated = fragTexCoord - vec2(1.0, 0.5);

	float m = mandelbrot(updated);

	finalColor = vec4(vec3(m), 1.0);
}
