#version 330

in vec3 vertex;
in vec3 normal; // normales

uniform mat4 modelViewProjMat;
uniform vec3 color;
uniform float delta_time;
uniform vec3 lightPos; // posición de la luz
uniform float intensity; // intensidad de la luz ambiental
uniform float indirectIntensity; // intensidad de la luz indirecta

out vec4 vertColor;

void main()
{
    // Olas
    vec3 direction1 = vec3(1.0, 0.0, 1.0);
    float steepness1 = 0.25;
    float waveLength1 = 1.0;

    vec3 direction2 = vec3(0.85, 0.0, 0.51);
    float steepness2 = 0.25;
    float waveLength2 = 0.5;

    vec3 direction3 = vec3(0.61, 0.0, 0.79);
    float steepness3 = 0.25;
    float waveLength3 = 0.3;

    // Cálculo de la dirección de la ola en el plano xz para cada una de las tres olas
    vec3 directionXZ1 = normalize(vec3(direction1.x, 0.0, direction1.z));
    vec3 directionXZ2 = normalize(vec3(direction2.x, 0.0, direction2.z));
    vec3 directionXZ3 = normalize(vec3(direction3.x, 0.0, direction3.z));

    // Cálculo de la constante k para cada una de las tres olas
    float k1 = 2.0 * 3.14159265358979323846 / waveLength1;
    float k2 = 2.0 * 3.14159265358979323846 / waveLength2;
    float k3 = 2.0 * 3.14159265358979323846 / waveLength3;

    // Cálculo de la variable f para cada una de las tres olas
    float f1 = k1 * (dot(directionXZ1, vertex) - delta_time * sqrt(9.8 / k1));
    float f2 = k2 * (dot(directionXZ2, vertex) - delta_time * sqrt(9.8 / k2));
    float f3 = k3 * (dot(directionXZ3, vertex) - delta_time * sqrt(9.8 / k3));

    // Cálculo del vector de transformación para cada una de las tres olas
    vec3 transformVector1 = vec3(directionXZ1.x * cos(f1), sin(f1), directionXZ1.z * cos(f1));
    transformVector1 = transformVector1 * (steepness1 / k1);

    vec3 transformVector2 = vec3(directionXZ2.x * cos(f2), sin(f2), directionXZ2.z * cos(f2));
    transformVector2 = transformVector2 * (steepness2 / k2);

    vec3 transformVector3 = vec3(directionXZ3.x * cos(f3), sin(f3), directionXZ3.z * cos(f3));
    transformVector3 = transformVector3 * (steepness3 / k3);

    // Aplicación de la transformación al vértice
    vec3 transformedVertex = vertex + transformVector1 + transformVector2 + transformVector3;

    // Cálculo de la normal
    vec3 tangent = vec3(1.0 - pow(transformedVertex.x, 2.0), 0.0, -transformedVertex.x) / length(vec3(1.0 - pow(transformedVertex.x, 2.0), 0.0, -transformedVertex.x));
    vec3 binormal = cross(normalize(vec3(0.0, 1.0, 0.0)), tangent);
    vec3 normalVector = normalize(cross(tangent, binormal));

    // Cálculo del color
    vec3 lightDirection = normalize(lightPos - transformedVertex);
    vec3 materialDiffuseColor = color.rgb;

    // Difuso
    vec3 diffuseColor = max(dot(normalVector, lightDirection), 0.0) * materialDiffuseColor;

    // Ambiente
    vec3 ambientColor = intensity * materialDiffuseColor;

    // Indirecta
    vec3 indirectLight = vec3(0.0);
    if (indirectIntensity > 0.0) {
        vec3 lightPosition = vec3(0, 0, 0); // esta es la posición de la luz, en el centro sin elevarse para las olas
        vec3 lightDirection = normalize(lightPosition - transformedVertex);
        vec3 indirectNormalVector = normalize(cross(tangent, binormal));
        indirectLight = indirectIntensity * materialDiffuseColor * max(dot(indirectNormalVector, lightDirection), 0.0);
    }

    // Suma de todos los componentes
    vec3 finalColor = ambientColor + diffuseColor + indirectLight;

    // Asignación de los valores de salida
    vertColor = vec4(finalColor, 1.0);
    gl_Position = modelViewProjMat * vec4(transformedVertex, 1.0);
}