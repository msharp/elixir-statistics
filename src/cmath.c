#include "erl_nif.h"
#include "src/protos.h"

static ERL_NIF_TERM cephes_hyp2f1(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    /*
       get the arguments values as doubles
    */
    double a,b,c,x,h;
    enif_get_double(env, argv[0], &a);
    enif_get_double(env, argv[1], &b);
    enif_get_double(env, argv[2], &c);
    enif_get_double(env, argv[3], &x);

    h = hyp2f1(a, b, c, x);
    return enif_make_double(env, h);
}


static ErlNifFunc funcs[] = {
  { "cephes_hyp2f1", 4, cephes_hyp2f1, 0 }
};

ERL_NIF_INIT(Elixir.Statistics.Math.Functions, funcs, NULL, NULL, NULL, NULL) 
