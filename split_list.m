function [FIRST, LAST] = split_list(START, END, ...    
STEP, NUM_CHUNKS, IDX)
% [FIRST, LAST] = split_frames_list(START_FRAME, END_FRAME, STEP_FRAME, NUM_SPLITS, IDX)
% This function splits a list of increasing numbers into NUM_SPLITS chunks,
% and returns the first and last number of the IDX'th chunk.

    % Set minimum num splits to 1
    num_chunks = max(NUM_CHUNKS, 1);

    % All frames
    items_all = START : STEP : END;

    % Count the number of frames
    num_items = length(items_all);

    % Set number of chunks to not exceed the number of frames
    num_chunks = min(num_chunks, num_items);

    % Number of frames per machine
    items_per_chunk = ceil(num_items / num_chunks);

    % Start frames on each job
    inds = 1 : items_per_chunk : num_items;
        
    % Truncate the indices
    IDX = IDX(IDX <= num_chunks);

    % First frame in the chunk for idx
    FIRST = items_all(inds(IDX));
        
    end_ind = min(num_items, inds(IDX) + items_per_chunk - 1);
  
    % Last frame in the chunk for idx.
    LAST = items_all(end_ind);

end