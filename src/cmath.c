#include "erl_nif.h"

static ERL_NIF_TERM cephes_hyp2f1(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    return enif_make_string(env, "1", ERL_NIF_LATIN1);
}


static ErlNifFunc funcs[] = {
  { "hyp2f1", 4, cephes_hyp2f1, 0 }
};

ERL_NIF_INIT(Elixir.Statistics.Math.Functions, funcs, NULL, NULL, NULL, NULL) 
