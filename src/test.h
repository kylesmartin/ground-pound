#ifndef TEST_H
#define TEST_H

#include <godot_cpp/classes/sprite2d.hpp>

namespace godot {
    class Test : public Sprite2D {
        GDCLASS(Test, Sprite2D)

        private:
            float time_passed;

        protected:
            static void _bind_methods();

        public:
            Test();
            ~Test();

            void _process(float delta);
    };
}

#endif
