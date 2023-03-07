#include "test.h"
#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void Test::_bind_methods() {
}

Test::Test() {
    // initialize any variables here
    time_passed=0.0;
}

Test::~Test() {
    // add cleanup here
}

void Test::_process(float delta) {
    time_passed += delta;

    Vector2 new_position = Vector2(
        10.0 + (10.0 + sin(time_passed * 2.0)),
        10.0 + (10.0 * cos(time_passed * 1.5))
    );

    set_position(new_position);
}
