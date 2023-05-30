//
//  GLFWWindow.cpp
//  alturas
//
//  Created by Antonio Jesús Rueda Ruiz on 06/02/14.
//  Copyright (c) 2014 Antonio Jesús Rueda Ruiz. All rights reserved.
//

#include <cstdlib>
#include "GLFWWindow.h"

GLFWWindow::GLFWWindow(int width, int height, const char *title, GLFWmonitor *monitor, GLFWwindow *share) {
    window = glfwCreateWindow(width, height, title, monitor, share);
    capturedEvents = 0;
    
    if (window) {
        glfwSetWindowUserPointer(window, this);
    }
    else {
        std::cerr << "Error al crear ventana" << std::endl;
        exit(1);
    }
}

void GLFWWindow::setCapturedEvents(int events) {
    capturedEvents = events;
    
    if (capturedEvents & KEYEVENT) glfwSetKeyCallback(window, keyCallback);
    if (capturedEvents & CHAREVENT) glfwSetCharCallback(window, charCallback);
    if (capturedEvents & SCROLLEVENT) glfwSetScrollCallback(window, scrollCallback);
    if (capturedEvents & MOUSEBUTTONEVENT) glfwSetMouseButtonCallback(window, mouseButtonCallback);
    if (capturedEvents & CURSORPOSEVENT) glfwSetCursorPosCallback(window, cursorPosCallback);
    if (capturedEvents & SIZEEVENT) glfwSetWindowSizeCallback(window, sizeCallback);
    if (capturedEvents & CLOSEEVENT) glfwSetWindowCloseCallback(window, closeCallback);
    if (capturedEvents & REFRESHEVENT) glfwSetWindowRefreshCallback(window, refreshCallback);
    if (capturedEvents & FOCUSEVENT) glfwSetWindowFocusCallback(window, focusCallback);
}


