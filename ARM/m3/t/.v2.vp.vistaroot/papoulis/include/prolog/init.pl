
:- style_check(-discontiguous).

mb_load(Path) :-
        model_builder_home(Model_Builder_Home),
        string_concat(Model_Builder_Home, '/include/', Include_Base),
        string_concat(Include_Base, Path, Full_Path),
        ensure_loaded(Full_Path).
