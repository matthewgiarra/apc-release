function [FIRST, LAST] = split_frames_list(START_FRAME, END_FRAME, ...
    STEP_FRAME, NUM_SPLITS, IDX)

    % Set minimum num splits to 1
    num_splits = max(NUM_SPLITS, 1);

    % All frames
    frames_all = START_FRAME : STEP_FRAME : END_FRAME;

    % Count the number of frames
    num_frames = length(frames_all);

    % Set number of chunks to not exceed the number of frames
    num_chunks = min(num_splits, num_frames);

    % Number of frames per machine
    num_chunks_per_idx = ceil(num_frames / num_chunks);

    % Start frames on each job
    frames_start = START_FRAME : num_chunks_per_idx : END_FRAME;

    % First frame in the chunk for idx
    FIRST = frames_start(IDX);

    % Last frame in the chunk for idx.
    LAST = min(END_FRAME, FIRST + num_chunks_per_idx - 1);

end