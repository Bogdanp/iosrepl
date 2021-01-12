#include <string.h>

#include "chezscheme.h"
#include "racketcs.h"

#include "repl.h"

int racket_init(const char *petite_path,
                const char *scheme_path,
                const char *racket_path,
                const char *repl_path) {
    racket_boot_arguments_t ba;
    memset(&ba, 0, sizeof(ba));
    ba.boot1_path = petite_path;
    ba.boot2_path = scheme_path;
    ba.boot3_path = racket_path;
    ba.exec_file = "iosrepl";
    racket_boot(&ba);
    racket_embedded_load_file(repl_path, 1);
    ptr mod = Scons(Sstring_to_symbol("quote"), Scons(Sstring_to_symbol("main"), Snil));
    racket_dynamic_require(mod, Sfalse);
    Sdeactivate_thread();
    return 0;
}

ptr eval_fn = NULL;

int repl_eval(char *code, char *out, size_t out_len) {
    Sactivate_thread();
    if (eval_fn == NULL) {
        ptr mod = Scons(Sstring_to_symbol("quote"), Scons(Sstring_to_symbol("main"), Snil));
        ptr fn = Scar(racket_dynamic_require(mod, Sstring_to_symbol("ev")));
        eval_fn = fn;
        Slock_object(fn);
    }
    ptr res = Scar(racket_apply(eval_fn, Scons(Sstring(code), Snil)));
    uptr res_len = Sbytevector_length(res);
    memcpy(out, Sbytevector_data(res), (res_len < out_len) ? res_len : out_len);
    if (res_len < out_len) {
        out[res_len] = 0;
    } else {
        out[out_len-1] = 0;
    }
    Sdeactivate_thread();
    return 1;
}
