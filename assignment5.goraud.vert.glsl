#version 300 es

#define MAX_LIGHTS 16

// struct definitions
struct AmbientLight {
    vec3 color;
    float intensity;
};

struct DirectionalLight {
    vec3 direction;
    vec3 color;
    float intensity;
};

struct PointLight {
    vec3 position;
    vec3 color;
    float intensity;
};

struct Material {
    vec3 kA;
    vec3 kD;
    vec3 kS;
    float shininess;
};


// an attribute will receive data from a buffer
in vec3 a_position;
in vec3 a_normal;

// camera position
uniform vec3 u_eye;

// transformation matrices
uniform mat4x4 u_m;
uniform mat4x4 u_v;
uniform mat4x4 u_p;

// lights and materials
uniform AmbientLight u_lights_ambient[MAX_LIGHTS];
uniform DirectionalLight u_lights_directional[MAX_LIGHTS];
uniform PointLight u_lights_point[MAX_LIGHTS];

uniform Material u_material;

// shading output
out vec4 o_color;

// Shades an ambient light and returns this light's contribution
vec3 shadeAmbientLight(Material material, AmbientLight light) {
    
    // TODO: Implement this method
    vec3 result = light.color * material.kA * light.intensity;


    return result;
}

// Shades a directional light and returns its contribution
vec3 shadeDirectionalLight(Material material, DirectionalLight light, vec3 normal, vec3 eye, vec3 vertex_position) {
    vec3 L = normalize(light.direction);
    vec3 N = normalize(normal);
    vec3 lightDiffuse = light.color * light.intensity;
    vec3 materialDiffuse = material.kD;
    float lambertianCoefficient = max(dot(N, -L), 0.0);
    vec3 Id = lightDiffuse * materialDiffuse * lambertianCoefficient;

    vec3 E = normalize(eye);
    vec3 R = reflect(L, N);
    vec3 lightSpecular = light.color * light.intensity;
    vec3 materialSpecular = material.kS;
    float specular = pow(max(dot(R, E), 0.0), material.shininess);
    vec3 Is = lightSpecular * materialSpecular * specular;
    // TODO: Implement this method
    return vec3(Id+Is);
}

// Shades a point light and returns its contribution
vec3 shadePointLight(Material material, PointLight light, vec3 normal, vec3 eye, vec3 vertex_position) {

    // TODO: Implement this method

    return vec3(0);
}

void main() {

    // TODO: GORAUD SHADING
    // TODO: Implement the vertex stage
    mat4x4 normalMatrix = inverse(u_v * u_m);
    normalMatrix = transpose(normalMatrix);
    vec3 N = vec3(normalMatrix * vec4(a_normal, 1.0));

    vec3 result = vec3(0,0,0);
    
    // TODO: Transform positions and normals
    // NOTE: Normals are transformed differently from positions. Check the book and resources.
    // TODO: Use the above methods to shade every light in the light arrays
    for(int i = 0; i < MAX_LIGHTS; i++) {
        result += shadeAmbientLight(u_material, u_lights_ambient[i]);
        result += shadeDirectionalLight(u_material, u_lights_directional[i], N, u_eye, a_position);
        result += shadePointLight(u_material, u_lights_point[i], N, u_eye, a_position);
    }
    // TODO: Accumulate their contribution and use this total light contribution to pass to o_color
    gl_Position = u_p * u_v * u_m * vec4(a_position, 1.0);
    o_color = vec4(result, 1.0);

    // TODO: Pass the shaded vertex color to the fragment stage
}