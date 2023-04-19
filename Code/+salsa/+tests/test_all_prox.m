%% Purpose: Test all base Prox Functions
function test_all_prox(verbos)
    arguments
        verbos logical = true
    end
    path  = "salsa.tests.test_";
    types = ["box", "l1", "l2_sq_", "iso"];
    args  = "(verbos)";
    div = "====================================";
    for type = types
        fprintf('%s\nTesting %sProx:\n',div, type);
        f = path + type + "Prox" + args;
        assert(eval(f),"Did not pass " + type + "Prox");
    end
    if verbos
        fprintf('%s\nAll Prox tests passed.\n%s\n',div,div)
    end
end