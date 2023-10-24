cmake_minimum_required(VERSION 3.16)

project(QmlCropImageTool VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick Widgets)

qt_standard_project_setup()

qt_add_resources(RC_SRC
    QmlCropImageTool.qrc
)

qt_add_executable(appQmlCropImageTool
    main.cpp
    CentralManager.cpp
    CropHandler.cpp
    CropHandler.h
    ${RC_SRC}
)

qt_add_qml_module(appQmlCropImageTool
    URI QmlCropImageTool
    VERSION 1.0
    QML_FILES Main.qml
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQmlCropImageTool PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQmlCropImageTool
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQmlCropImageTool
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Widgets
)

include(GNUInstallDirs)
install(TARGETS appQmlCropImageTool
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
