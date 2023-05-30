//
//  PHViewer.h
//  alturas
//
//  Created by Antonio Jesús Rueda Ruiz on 06/02/14.
//  Copyright (c) 2014 Antonio Jesús Rueda Ruiz. All rights reserved.
//

#ifndef _PHViewer_h
#define _PHViewer_h

#include "util/GLFWWindow.h"

class PHViewer : public GLFWWindow {
    /** VAO & vertex buffers */
    GLuint VAO, verticesVBO, indicesVBO;
    size_t numIndices;

    /** Shader program & parameters */
    GLuint program;

    // --------------------------------------------
    // MARAKATUSA
    GLuint modelViewProjMatParam,
           vertexParam,
           colorParam,
           delta_timeParam,
           lightPosParam,
           intensityParam,
           indirectIntensityParam,
           normalParam;
    // --------------------------------------------

    /** Model, view and projection matrices */
    glm::mat4 modelMat, viewMat, projMat;

    /** Shader reader
     Creates null terminated string from file */
    void checkError(GLint status, const char *msg);

    /** Error printing function */
    char *readShaderSource(const char* shaderFile);

    /** Compile error printing function */
    void checkShaderError(GLint status, GLint shader, const char *msg);

    /** Program link error printing function */
    void checkProgramError(GLint status, GLint program, const char *msg);

public:

    /** Constructor */
    PHViewer();

    /** Setup OpenGL */
    void initGL();

    /** Load shaders */
    void loadShaders(const GLchar* vShaderFile, const GLchar* fShaderFile);
    /** Delete shaders */
    void deleteShaders();

    /** Load Model */
    void loadModel(const char *fileName);
    /** Delete model */
    void deleteModel();

    /** Resize event */
    void resizeEvent(int width, int height) { tbReshape(width, height); }

    /** Mouse button event: orbit around object */
    void mouseButtonEvent(int button, int action, int mods) {
        double x, y;
        getCursorPos(x, y);
        tbMouse(button, action, floor(x), floor(y));
    }

    /** Cursor change position event: orbit around object */
    void cursorPosEvent(double x, double y) { tbMotion(floor(x), floor(y)); }
    /** Scroll event: zoom in/out */
    void scrollEvent(double xoffset, double yoffset) { viewMat = glm::translate(viewMat, glm::vec3(0.0f, 0.0f, yoffset)); }

    /** Draw scene */
    void draw();
};

#endif