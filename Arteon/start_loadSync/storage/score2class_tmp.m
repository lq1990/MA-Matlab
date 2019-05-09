function class = score2class_tmp(score, score_max, score_min, n_output_classes )

    part = 1.0 / n_output_classes;

	pos = (score - score_min) / (score_max - score_min + 1e-8);

	pos_idx = floor(pos / part);

% 	zs = zeros(n_output_classes, 1);
% 	zs(pos_idx, 0) = 1;
% 	return zs;

    class = pos_idx + 1;
end

