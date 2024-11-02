shader_type canvas_item;

uniform vec2 node_size; // Size of the node (the sprite or the canvas item)
uniform vec2 node_position; // Position of the node in world space
uniform vec2 player_position; // Player position
uniform float darkness; // Darkness level
uniform int light_radius; // Light radius in pixels

void fragment() {
    vec2 uv = UV * node_size + node_position; // Convert UV to pixel position
    vec2 player_cell = floor(player_position / node_size); // Get the player cell position

    // Calculate the distance from the current pixel to the player
    float distance = length(uv - (player_cell * node_size)); // Center light on the player
    
    // Calculate a blocky light intensity
    float light_intensity = step(float(light_radius), distance); // Step function for blockiness

    // Set the fragment color based on the light intensity and darkness
    vec4 color = vec4(1.0, 1.0, 1.0, 1.0 - (light_intensity * darkness));
    COLOR = color;
}
