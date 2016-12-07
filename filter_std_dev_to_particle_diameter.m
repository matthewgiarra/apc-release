function DIAMETER_EQUIV = filter_std_dev_to_particle_diameter(...
    FILTER_STD_DEV, REGION_LENGHT)
% Equivalent particle diameter from the standard 
% deviation of an RPC filter.

    DIAMETER_EQUIV = sqrt(2) / (pi * FILTER_STD_DEV) * REGION_LENGHT;

end