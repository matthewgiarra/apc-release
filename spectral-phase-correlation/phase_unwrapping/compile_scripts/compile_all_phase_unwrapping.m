function compile_all_phase_unwrapping

% Compile the branch cut algorithm
fprintf(1, 'Compiling "calculate_branch_cuts_goldstein.m" to MEX...\n\n');
compile_calculate_branch_cuts_goldstein;

% Compile the phase residue finding code.
fprintf(1, 'Compiling "calculate_phase_residues.m" to MEX...\n\n');
compile_calculate_phase_residues;

% Compile the flood fill algorithm
fprintf(1, 'Compiling "FloodFill.m" to MEX...\n\n');
compile_FloodFill;

% Compile the flood fill algorithm
fprintf(1, 'Compiling "make_flags_matrix.m" to MEX...\n\n');
compile_make_flags_matrix;

% Compile the flood fill algorithm
fprintf(1, 'Compiling "remove_dipoles.m" to MEX...\n\n');
compile_remove_dipoles;



end