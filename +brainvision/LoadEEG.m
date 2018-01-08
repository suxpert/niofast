function result = LoadEEG(file)
% LoadEEG load eeg format data
% Usage: result = LoadEEG(file)
%
% Copyright (C) 2016-2017 LiTuX, all rights reserved.


%%
if nargin == 0
    [fname, fpath] = uigetfile('*.vhdr', 'Select vhdr file for read');
    file = fullfile(fpath, fname);
    fprintf('>> %s(''%s'')\n', mfilename, file);
end

[folder, name, ext] = fileparts(file);
basename = [folder, filesep, name];

switch lower(ext)
    case '.eeg'
    case '.vhdr'
    case '.vmrk'
    otherwise
        error('Unrecognized file format %s.', ext);
end

headerfile = fullfile(folder, [name, '.vhdr']);
hdrheader  = 'Brain Vision Data Exchange Header File Version 1.0';
hdr = ReadBVini(headerfile, hdrheader);

markerfile = fullfile(folder, hdr.Common_Infos.MarkerFile);
if ~exist(markerfile, 'file')
    markerfile = [basename, '.vmrk'];
    if ~exist(markerfile, 'file')
        error('Can not stat a corresponding marker file.');
    end
end

datafile = fullfile(folder, hdr.Common_Infos.DataFile);
if ~exist(datafile, 'file')
    datafile = [basename, '.eeg'];
    if ~exist(datafile, 'file')
        error('Can not stat a corresponding data file.');
    end
end

mrkheader = 'Brain Vision Data Exchange Marker File, Version 1.0';
mrk = ReadBVini(markerfile, mrkheader);


%% phase vhdr contents
if ~strcmpi(hdr.Common_Infos.DataFormat, 'BINARY')
    error('Unsupportted data format %s!', hdr.Common_Infos.DataFormat);
end
if ~strcmpi(hdr.Common_Infos.DataOrientation, 'MULTIPLEXED')
    error('Unsupportted data orientation %s!', hdr.Common_Infos.DataOrientation);
end

nchannels = hdr.Common_Infos.NumberOfChannels;
result.NumberOfChannels = nchannels;

% SamplingInterval is in microseconds so:
result.SamplingRate = 1e6/hdr.Common_Infos.SamplingInterval;

result.ChannelNames = structfun(@(x) strtok(x, ','), hdr.Channel_Infos, 'UniformOutput', false);

marks = struct2cell(mrk.Marker_Infos);
% the 1st 3 fields are used, drop the others.
[mtype, remain] = strtok(marks, ',');
[descr, remain] = strtok(remain, ',');
position = strtok(remain, ',');

mnumber = cellfun(@(x) str2double(x(2:end)), descr);

result.MarkerType = mtype;
result.Marker = mnumber;
result.Latency = str2double(position);

fid = fopen(datafile);
autoclosefile = onCleanup(@() fclose(fid));
if fid == -1
    error('Error reading %s.', datafile);
end

fseek(fid, 0, 'eof');
filesize = ftell(fid);

frewind(fid);

if mod( filesize, result.NumberOfChannels ) ~= 0
    warning('File size mismatch!');
end

switch hdr.Binary_Infos.BinaryFormat
    case 'INT_16'
        formats = '*int16';
        datasize = 2;
    otherwise
        error('Data format %s is not yet supported.', hdr.Binary_Infos.BinaryFormat);
end

chlength = filesize / result.NumberOfChannels / datasize;
data = fread(fid, [nchannels, chlength], formats);

result.data = data;

result.hdr = hdr;
result.mrk = mrk;
end

%%

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
    if ~strcmp(thisline, expectedheader)
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
            error('%s: at line %d, unclosed brackets.', file, nline);
        end
        section = thisline(2: idx-1);
        section( section == 32 | section == 9 ) = '_';
        if ~isempty(lastsection)
            info.(lastname) = lastsection;
            lastsection = [];
        end
        lastname = section;
        
        if strcmp(section, 'Comment')
            fprintf(2, '%s: at line %d, analysing of vhdr comment is not yet supported.', file, nline);
        end
        
    else
        if isempty(lastname)
            fprintf(2, '%s: at line %d, skip orphan info.', file, nline);
            continue;
        end
        
        if strcmp(lastname, 'Comment')
%             fprintf(2, 'Analysing of vhdr comment is not yet supported.');
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

