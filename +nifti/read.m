function [hdr, info, data] = read(file)
% READ read nifti+ file (nii or nii.gz)
% Usage: [hdr, info, data] = read(file)
%
% Copyright (C) 2017-2018 LiTuX, all rights reserved.

%%
if ~exist(file, 'file')
    error('Can not find file %s.', file);
end

fis = java.io.FileInputStream(file);
autoclosefis = onCleanup(@() fis.close);

[~, ~, ext]  = fileparts(file);
if strcmpi(ext, '.gz')
    zis = java.util.zip.GZIPInputStream(fis);
    autoclosezis = onCleanup(@() zis.close);
    inputstream = zis;
else
    inputstream = fis;
end

iou = org.apache.commons.io.IOUtils;

hsize = iou.toByteArray(inputstream, 4);
magicnum = typecast(hsize, 'int32');

headersize.nifti1 = int32(348);
headersize.nifti2 = int32(540);
switch magicnum
    case headersize.nifti1
        ftype = 'nifti1';
        bswap = false;
    case swapbytes(headersize.nifti1)
        ftype = 'nifti1';
        bswap = true;
    case headersize.nifti2
        ftype = 'nifti2';
        bswap = false;
    case swapbytes(headersize.nifti2)
        ftype = 'nifti2';
        bswap = true;
    otherwise
        error('%s: file %s is not a NifTi file.', mfilename, file);
end % switch header size

[header, datacast, datatype] = NifTi_header(ftype, bswap);
hdr.(header{1, 2}) = headersize.(ftype);

buffer = iou.toByteArray(inputstream, headersize.(ftype)-4);
jj = 0;
for ii = 2: size(header, 1)
    nbytes = header{ii, 4};
    tmp = typecast(buffer(jj+(1: nbytes))', datacast.(header{ii, 1}){1});
    hdr.(header{ii, 2}) = datacast.(header{ii, 1}){2}(tmp);
    jj = jj + nbytes;
end

% TODO: read the extension part?

% parse the header structure
if nargout >= 2
    info = hdrparse(hdr);
end

if nargout == 3
    if datatype.isKey(hdr.datatype)
        convert = datatype(hdr.datatype);
    else
        error('%g: unsupported data type %d.', hdr.datatype);
    end
    inputstream.skip( double(hdr.vox_offset)-hdr.sizeof_hdr );
    
    nbytes = prod(double(hdr.dim(2: hdr.dim(1)+1))) * convert{3};
    bytedata = iou.toByteArray(inputstream, nbytes);
%     bytedata = iou.toByteArray(inputstream);
    tmp = typecast(bytedata, convert{1});
    dat = convert{4}(tmp);
    
    data = reshape(dat, hdr.dim(2: hdr.dim(1)+1));
    
    % Plz ref. to section #DATA SCALING in nifti1.h
    if hdr.scl_slope ~= 0 && hdr.scl_slope ~= 1
        data = data * hdr.scl_slope;
    end
    if hdr.scl_inter ~= 0
        data = data + hdr.scl_inter;
    end
    
end % if read data

end % function


function info = hdrparse(hdr)
%%

if hdr.dim(1) >= 5 || hdr.dim(6) > 1
    % TODO, ref. to section #INTERPRETATION OF VOXEL DATA in nifti1.h
    % TODO, also check the intent_code et al.
    warning('%s: High dimension data is not fully supported yet.', mfilename);
end

spunit = bitand(hdr.xyzt_units, 7);
switch spunit
    case 1      % meter
        spscale = 1000;
    case 2      % millimeter
        spscale = 1;
    case 3      % micrometer
        spscale = 0.001;
    otherwise
        warning('%s: unsupported xyz unit %d.', mfilename, spunit);
end

tunit = hdr.xyzt_units - spunit;
switch tunit
    case 8      % seconds
        tscale = 1;
    case 16     % milliseconds
        tscale = 0.001;
    case 24     % microseconds
        tscale = 1e-6;
%     case 32     % Hertz
%     case 40     % ppm: part per million
%     case 48     % randians per second
    otherwise
        warning('%s: unsupported t unit %d.', mfilename, spunit);
end

if hdr.qform_code == 0
    % METHOD 1 in nifti1.h
    qform = diag([double(hdr.pixdim(2:4)), 1]);
else
    % METHOD 2, some of the following code are from `nifti_quatern_to_mat44`
    
    qfac = double(hdr.pixdim(1));
    if qfac ~= 1 && qfac ~= -1
        warning('%s: incorrect qfac.', mfilename);
        qfac = 1;
    end
    
    b = double(hdr.quatern_b);
    c = double(hdr.quatern_c);
    d = double(hdr.quatern_d);
    
    tmp = b^2 + c^2 + d^2;
    
    a = 1 - tmp;
    if a < 1e-7
        a = 1/sqrt(tmp);
        b = b*a;
        c = c*a;
        d = d*a;
        a = 0;
    else
        a = sqrt(a);
    end
    
    aa = a^2;
    bb = b^2;
    cc = c^2;
    dd = d^2;
    ab = a*b;
    ac = a*c;
    ad = a*d;
    bc = b*c;
    bd = b*d;
    cd = c*d;
    
    R = [
        aa+bb-cc-dd,    2*(bc - ad),    2*(bd + ac);
        2*(bc + ad),    aa+cc-bb-dd,    2*(cd - ab);
        2*(bd - ac),    2*(cd + ab),    aa+dd-bb-cc;
        ];
    
    if abs(det(R) - 1) > 1e-5
        warning('%s: qform is not a rigid rotation.', mfilename);
    end
    tmp = double(hdr.pixdim(2:4));
    tmp(3) = tmp(3) * qfac;
    tmp = bsxfun(@times, R, tmp');
    qform = [tmp, double([hdr.qoffset_x; hdr.qoffset_y; hdr.qoffset_z]); 0 0 0 1];
end

if hdr.sform_code > 0
    sform = double([hdr.srow_x; hdr.srow_y; hdr.srow_z; 0 0 0 1]);
else
    sform = qform;
end

info.dim = double(hdr.dim(1));
info.resolution = double(hdr.pixdim(2:4)) * spscale;
info.TR = double(hdr.pixdim(5)) * tscale;
info.size = double(hdr.dim(2:4));
info.nvolume = double(hdr.dim(5));
info.qform = qform;
info.sform = sform;

end % function
