cmake_minimum_required(VERSION 3.14)
project(Flashcards)

#find_package(Boost REQUIRED COMPONENTS system)
find_package(simdjson REQUIRED)

add_executable(flashcards main.cpp)
target_link_libraries(flashcards PRIVATE simdjson)

install(TARGETS flashcards DESTINATION bin)
