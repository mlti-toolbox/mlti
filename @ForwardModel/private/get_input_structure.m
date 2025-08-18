function [in_structure, in_sizes, MOchi2input] = get_input_structure(fm)
    % generate in_structure TODO make this more elegant
    % TODO handle log_args
    if isfield(fm.c_args, "film_orient")
        film_orient = fm.c_args.film_orient;
    else
        film_orient = [];
    end

    if isfield(fm.c_args, "sub_orient")
        sub_orient = fm.c_args.sub_orient;
    else
        sub_orient = [];
    end

    if isfield(fm.c_args, "euler_seq")
        seq = fm.c_args.euler_seq;
    else
        seq = [];
    end

    [kf, of] = fm.format_ko(fm.c_args.film_isotropy, film_orient, 'f', seq);
    [ks, os] = fm.format_ko(fm.c_args.sub_isotropy, sub_orient, 's', seq);

    if fm.c_args.inf_sub_thick
        hs = [];
    else
        hs = "hs";
    end

    if fm.c_args.phase_only
        P = [];
        Rf = [];
        Rs = [];
    else
        P = "P";
        Rf = "Rf";
        Rs = "Rs";
    end

    in_structure{1} = [kf, "Cf", "αf", Rf, "hf", ks, "Cs", "αs", Rs, hs];
    in_structure{2} = [of, os];
    in_structure{3} = ["sx", "sy", P];

    in_sizes = [length(in_structure{1}), length(in_structure{2}), length(in_structure{3})];

    MOchi2input = NaN;
end