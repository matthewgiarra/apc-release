function FILTER_STD_DEV = particle_diameter_to_filter_std_dev(...
    DIAMETER_EQUIV, REGION_LENGHT)
    % Equivalent particle diameter from the standard 
    % deviation of an RPC filter.
    
     FILTER_STD_DEV = sqrt(2) / (pi * DIAMETER_EQUIV) * REGION_LENGHT;

end