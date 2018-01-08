function Writeniigz( template, data, file )
%

%%
if isstruct(template) && isfield(template, 'sizeof_hdr')
    hdr = template;
elseif exist(template, 'file')
    hdr = Readniigz(template);
else
    error('Unrecognized template %s.', inputname(1));
end

%%

headersize.nifti1 = int32(348);
headersize.nifti2 = int32(540);
switch hdr.sizeof_hdr
    case headersize.nifti1
        ftype = 'nifti1';
    case headersize.nifti2
        ftype = 'nifti2';
end % switch header size

[header, ~, datatype] = NifTi_header(ftype);

% modify the header to fit the data
sz = size(data);
hdr.dim(1) = length(sz);
hdr.dim(2: hdr.dim(1)+1) = sz;
hdr.scl_slope(1) = 1;
hdr.scl_inter(1) = 0;

typedef.uint8  = [  2,  8];         %/*! unsigned char. */
typedef.int16  = [  4, 16];         %/*! signed short. */
typedef.int32  = [  8, 32];         %/*! signed int. */
typedef.single = [ 16, 32];         %/*! 32 bit float. */
typedef.double = [ 64, 64];         %/*! 64 bit float = double. */
typedef.int8   = [256,  8];         %/*! signed char. */
typedef.uint16 = [512, 16];         %/*! unsigned short. */
typedef.uint32 = [768, 32];         %/*! unsigned int. */
typedef.int64  = [1024,64];         %/*! signed long long. */
typedef.uint64 = [1280,64];         %/*! unsigned long long. */

if datatype.isKey(hdr.datatype)
    convert = datatype(hdr.datatype);
    if ~isa(data, convert{1})
        warning('Data type differes from template!');
        tt = class(data);
        if isfield(typedef, tt)
            hdr.datatype(1) = typedef.(tt)(1);
            hdr.bitpix(1)   = typedef.(tt)(2);
        else
            error('%s: unsupported data type %s.', tt);
        end
    end
else
    error('%s: unsupported data type %d.', hdr.datatype);
end

buffer = zeros(1, hdr.vox_offset, 'uint8');
index  = 0;
for ii = 1: size(header, 1)
    nbytes = header{ii, 4};
    thedat = hdr.(header{ii, 2});
    if strcmp(header{ii, 1}, 'char')
        tmp = [uint8(thedat), zeros(1, nbytes-length(thedat), 'uint8')];
    else
        tmp = typecast(thedat, 'uint8');
    end
    buffer(index+(1: nbytes)) = tmp;
    index = index + nbytes;
end

dat = typecast(data(:), 'uint8');

fos = java.io.FileOutputStream(file);
zos = java.util.zip.GZIPOutputStream(fos);

autoclosezos = onCleanup(@() zos.close);
autoclosefos = onCleanup(@() fos.close);
% autogc = onCleanup(@() java.lang.Runtime.getRuntime.gc);

zos.write(buffer);
zos.write(dat);

end
