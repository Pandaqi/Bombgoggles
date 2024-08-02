shader_type canvas_item;

// @NOTE: these are in REAL pixels; working with relative UV is a nightmare and doesn't mantain proper circle shape
uniform vec2[20] hole_centers;
uniform float[20] hole_radii;
uniform vec4 color : source_color;
uniform vec2 size_real;
uniform sampler2D noise;
uniform float noise_border_threshold;

void fragment() {
	vec3 rgb = color.rgb;
	float alpha = 1.0;
	vec2 uv = UV * size_real;
	
	float noise_val_raw = texture(noise, UV).r;
	rgb += vec3(0.075) * noise_val_raw;
	
	for(int i = 0; i < 20; i++)
	{
		float dist = distance(uv, hole_centers[i]);
		float radius = hole_radii[i];
		if(dist <= radius)
		{
			alpha = 0.0;
			break;
		}
	}
	
	// Essentially, we want our noise to create random jagged edges
	// Once we get close to the edge (dist < 1.0), start multiplying the noise value by that distance, which means it will get lower and lower the further you go
	// Which means we get nice hard cutoffs at some point, but at the _start_ most of the shape will be neatly continued for some pixels
	float dist_to_edge = min( min( min(uv.x, size_real.x - uv.x), min(uv.y, size_real.y - uv.y) ) / noise_border_threshold, 1.0);
	float noise_val = noise_val_raw * dist_to_edge;
	if(dist_to_edge < 1.0 && noise_val <= 0.25)
	{
		alpha = 0.0;
	}
	
	COLOR.rgb = rgb;
	COLOR.a = alpha;
}
