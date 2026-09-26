function sort_vars(filename)
    lines = readlines(filename);

    startIdx = find(~cellfun(@isempty, regexpi(lines, '\] = ft_\d+\(\{', 'once')));
    endIdx   = find(contains(lines, "] = ct{:};"));
    
    for i = numel(startIdx):-1:1
        lines(startIdx(i):endIdx(i)) = [];
    end
    
    insertLines = [];
    updateInsertLines();
    insert("if nargout > 0", insertLines(1));
    insert("end", insertLines(1)+1)
    updateInsertLines();

    addGetValLines()
    
    nums = str2double(regexp(lines, '(?<=t)\d+', 'match', 'once'));
    maxNum = max(nums, [], 'omitnan');
    for i = maxNum:-1:1
        pattern = "(?<![A-Za-z0-9])t" + string(i) + "(?!\d)";
        rows = find(~cellfun(@isempty, regexpi(lines, pattern, 'once')));
        if ~isempty(rows)
            funs_that_use = unique(discretize(rows(2:end), [1; insertLines; length(lines)]));
            if funs_that_use(1) == 1
                move(rows(1), rows(2)-1)
            elseif isscalar(funs_that_use)
                move(rows(1), min(rows(2)-1, insertLines(funs_that_use-1)))
            else
                move(rows(1), min(rows(2)-1, insertLines(1)))
            end
        end
    end
    updateInsertLines()
    for i = 2:numel(insertLines)-1
        if lines(insertLines(i)-1) ~= "end"
            insert("end", insertLines(i))
            updateInsertLines()
        end
    end
    replace_nargout_w_function()
    writelines(lines, filename + "auto_sorted.m")
    function move(current,new)
        if current < new
            lines(current:new,:) = lines([current+1:new, current],:);
        else
            new = new + 1;
            lines(new:current,:) = lines([current, new:current-1],:);
        end
        updateInsertLines();
    end
    function insert(newLine, pos)
        lines = [lines(1:pos-1); newLine; lines(pos:end)];
    end
    function updateInsertLines()
        insertLines = find(startsWith(strtrim(lines), "if nargout >"));
    end
    function addGetValLines()
        lines(1) = regexprep(lines(1), '(?<=\[)([^,\]]+),.*?(?=\])', '$1,Jac');
        % Extract input names from the function definition
        funcLine = lines(1);
        tokens = regexp(funcLine, '\((.*?)\)', 'tokens', 'once');
        inputNames = strtrim(split(tokens{1}, ','));
    
        % Rename inputs in function definition
        for k = 1:numel(inputNames)
            pattern = "(?<![A-Za-z0-9_])" + regexptranslate("escape", inputNames(k)) + "(?![A-Za-z0-9_])";
            lines(1) = regexprep(lines(1), pattern, inputNames(k) + "i");
        end    
        % Insert get_val line for each input
        insertIdx = 2;

        insertJac = insertLines(2) - 1;
        insert("Jac = [];", insertJac);
        insertJac = insertJac + 1;
    
        for k = 1:numel(inputNames)
            varName = inputNames(k);
            insert("Jac = addGradient(Jac, "+varName+"i, @get_grad_"+varName+");", insertJac)
            newLine = varName + " = get_val(" + varName + "i);";
            insert(newLine, insertIdx)
            insertIdx = insertIdx + 1;
            insertJac = insertJac + 2;
        end

        updateInsertLines();
    end
    function replace_nargout_w_function()
        for w = 2:numel(insertLines)
            if w == numel(insertLines)
                tokens = regexp(lines(end-3), '^\s*(\S+)\s*=', 'tokens', 'once');
            else
                tokens = regexp(lines(insertLines(w+1)-2), '^\s*(\S+)\s*=', 'tokens', 'once');
            end
            varName = string(tokens{1});
            lines(insertLines(w)) = "function " + varName + " = get_" + varName + "()";
        end
        lines(insertLines(1)) = "if nargout > 1";
    end
end