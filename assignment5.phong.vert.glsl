#version 300 es

// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// output to fragment stage

out vec3 o_vertex_normal_world;
out vec3 o_vertex_position_world;
// TODO: Create any needed `out` variables here
out vec4 o_color;

void main() {

    // TODO: PHONG SHADING
    // TODO: Implement the vertex stage
    // TODO: Transform positions and normals
    // NOTE: Normals are transformed differently from positions. Check the book and resources.
    // TODO: Create new `out` variables above outside of main() to store any results
    vec4 vertex_position_world = u_m * vec4(a_position, 1.0);

    mat3 norm_matrix = transpose(inverse(mat3(u_m)));
    vec3 vertex_normal_world = normalize(norm_matrix * a_normal);
    gl_Position = u_p * u_v * vertex_position_world;
    o_vertex_normal_world = vertex_normal_world.xyz;
    o_vertex_position_world = vertex_position_world.xyz;

}