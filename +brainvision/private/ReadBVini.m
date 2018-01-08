function info = ReadBVini(file, expectedheader)
% function for reading the Brain Vision(R) ini-like file.
%
% Copyright (C) 2016 LiTuX, all rights reserved.

%%
if nargin == 1
    expectedheader = '';
end

fid = fopen(file, 'r', 'n', 'UTF-8');
% fid = fopen(file, 'r');
if fid == -1
    error('Error reading file %s.', file);
end
autoclosefile = onCleanup(@() fclose(fid));

%% read each section of the file
nline = 0;

if ~isempty(expectedheader)
    % the first line should be the file format version information:
    % expectedheader = 'Brain Vision Data Exchange ...';
    thisline = fgetl(fid);
    nline = 1;
    if ~streq(thisline, expectedheader)
        error('Unrecognized file %s, not a valid Brain Vision vhdr file?', file);
    end
end

% read all sections
lastsection = [];
lastname = '';
while ~feof(fid)
    thisline = fgetl(fid);
    nline = nline + 1;
    if isempty(thisline) || all(thisline == 9 | thisline == 32)
        % empty line.
        continue;
    elseif thisline(1) == ';'
        % one-line comment
        continue;
    elseif thisline(1) == '['
        % start of a section
        idx = strfind(thisline, ']');
        if isempty(idx)
            error('at line %d, unclosed brackets.', nline);
        end
        section = thisline(2: idx-1);
        section( section == 32 | section == 9 ) = '_';
        if ~isempty(lastsection)
            info.(lastname) = lastsection;
            lastsection = [];
        end
        lastname = section;
        
        if streq(section, 'Comment')
            warning('at line %d: analysing of vhdr comment is not yet supported.', nline);
        end
        
    else
        if isempty(lastname)
            warning('at line %d: skip orphan info.', nline);
            continue;
        end
        
        if streq(lastname, 'Comment')
%             warning('Analysing of vhdr comment is not yet supported.');
        else
            % default behavior of a section
            [ss, ee] = regexp(thisline, '\s*=\s*');
            key = thisline(1: (ss-1));
            value = thisline((ee+1): end);
            tmp = str2double(value);
            if ~isnan(tmp)
                % this is a `real` number
                value = tmp;
            end
            lastsection.(key) = value;
        end
    end
end

% finnally add the last section to argout:
if ~isempty(lastsection)
    info.(lastname) = lastsection;
end
end

% End Of File
