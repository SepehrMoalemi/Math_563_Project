%% Purpose: Proprietary Stochastic Solver
% Randomly choose one of the already developed algorithms
function algorithm = stewchastic()
    algorithms = ["douglasrachfordprimal", ...
                  "douglasrachfordprimaldual", ...
                  "admm", ...
                  "chambollepock"];
    indx = randi([1 length(algorithms)]);
    algorithm = algorithms(indx);
end