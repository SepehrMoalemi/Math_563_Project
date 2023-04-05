%% Purpose: Test all base Prox Functions
function test_all_prox(verbos)
    arguments
        verbos logical = true
    end
    path  = "salsa.tests.test_";
    types = ["box", "l1", "l2_sq_", "iso"];
    args  = "(verbos)";
    for type = types
        f = path + type + "Prox" + args;
        assert(eval(f),"Did not pass " + type + "Prox");
    end
    disp("All Prox tests passed.")
end