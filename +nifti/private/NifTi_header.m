function [st, datacast, datatype] = NifTi_header(version, byteswap)
% define the header structure of NifTi file

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code are copied directly from nifti1.h
%                         /*************************/  /************************/
% struct nifti_1_header { /* NIFTI-1 usage         */  /* ANALYZE 7.5 field(s) */
%                         /*************************/  /************************/
% 
%                                            /*--- was header_key substruct ---*/
%  int   sizeof_hdr;    /*!< MUST be 348           */  /* int sizeof_hdr;      */
%  char  data_type[10]; /*!< ++UNUSED++            */  /* char data_type[10];  */
%  char  db_name[18];   /*!< ++UNUSED++            */  /* char db_name[18];    */
%  int   extents;       /*!< ++UNUSED++            */  /* int extents;         */
%  short session_error; /*!< ++UNUSED++            */  /* short session_error; */
%  char  regular;       /*!< ++UNUSED++            */  /* char regular;        */
%  char  dim_info;      /*!< MRI slice ordering.   */  /* char hkey_un0;       */
% 
%                                       /*--- was image_dimension substruct ---*/
%  short dim[8];        /*!< Data array dimensions.*/  /* short dim[8];        */
%  float intent_p1 ;    /*!< 1st intent parameter. */  /* short unused8;       */
%                                                      /* short unused9;       */
%  float intent_p2 ;    /*!< 2nd intent parameter. */  /* short unused10;      */
%                                                      /* short unused11;      */
%  float intent_p3 ;    /*!< 3rd intent parameter. */  /* short unused12;      */
%                                                      /* short unused13;      */
%  short intent_code ;  /*!< NIFTI_INTENT_* code.  */  /* short unused14;      */
%  short datatype;      /*!< Defines data type!    */  /* short datatype;      */
%  short bitpix;        /*!< Number bits/voxel.    */  /* short bitpix;        */
%  short slice_start;   /*!< First slice index.    */  /* short dim_un0;       */
%  float pixdim[8];     /*!< Grid spacings.        */  /* float pixdim[8];     */
%  float vox_offset;    /*!< Offset into .nii file */  /* float vox_offset;    */
%  float scl_slope ;    /*!< Data scaling: slope.  */  /* float funused1;      */
%  float scl_inter ;    /*!< Data scaling: offset. */  /* float funused2;      */
%  short slice_end;     /*!< Last slice index.     */  /* float funused3;      */
%  char  slice_code ;   /*!< Slice timing order.   */
%  char  xyzt_units ;   /*!< Units of pixdim[1..4] */
%  float cal_max;       /*!< Max display intensity */  /* float cal_max;       */
%  float cal_min;       /*!< Min display intensity */  /* float cal_min;       */
%  float slice_duration;/*!< Time for 1 slice.     */  /* float compressed;    */
%  float toffset;       /*!< Time axis shift.      */  /* float verified;      */
%  int   glmax;         /*!< ++UNUSED++            */  /* int glmax;           */
%  int   glmin;         /*!< ++UNUSED++            */  /* int glmin;           */
% 
%                                          /*--- was data_history substruct ---*/
%  char  descrip[80];   /*!< any text you like.    */  /* char descrip[80];    */
%  char  aux_file[24];  /*!< auxiliary filename.   */  /* char aux_file[24];   */
% 
%  short qform_code ;   /*!< NIFTI_XFORM_* code.   */  /*-- all ANALYZE 7.5 ---*/
%  short sform_code ;   /*!< NIFTI_XFORM_* code.   */  /*   fields below here  */
%                                                      /*   are replaced       */
%  float quatern_b ;    /*!< Quaternion b param.   */
%  float quatern_c ;    /*!< Quaternion c param.   */
%  float quatern_d ;    /*!< Quaternion d param.   */
%  float qoffset_x ;    /*!< Quaternion x shift.   */
%  float qoffset_y ;    /*!< Quaternion y shift.   */
%  float qoffset_z ;    /*!< Quaternion z shift.   */
% 
%  float srow_x[4] ;    /*!< 1st row affine transform.   */
%  float srow_y[4] ;    /*!< 2nd row affine transform.   */
%  float srow_z[4] ;    /*!< 3rd row affine transform.   */
% 
%  char intent_name[16];/*!< 'name' or meaning of data.  */
% 
%  char magic[4] ;      /*!< MUST be "ni1\0" or "n+1\0". */
% 
% } ;                   /**** 348 bytes total ****/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent nifti_1_header;
if isempty(nifti_1_header)
% data structure is copied from nifti1.h, with a slightly modification (single char -> int8)
%                                 /*************************/  /************************/
nifti_1_header = {%               /* NIFTI-1 usage         */  /* ANALYZE 7.5 field(s) */
%                                 /*************************/  /************************/
%                                                    /*--- was header_key substruct ---*/
'int'   'sizeof_hdr',    1,  4; % /* MUST be 348           */  /* int sizeof_hdr;      */
'char'  'data_type',    10, 10; % /* ++UNUSED++            */  /* char data_type[10];  */
'char'  'db_name',      18, 18; % /* ++UNUSED++            */  /* char db_name[18];    */
'int'   'extents',       1,  4; % /* ++UNUSED++            */  /* int extents;         */
'short' 'session_error', 1,  2; % /* ++UNUSED++            */  /* short session_error; */
'char'  'regular',       1,  1; % /* ++UNUSED++            */  /* char regular;        */
'int8'  'dim_info',      1,  1; % /* MRI slice ordering.   */  /* char hkey_un0;       */
                              
%                                               /*--- was image_dimension substruct ---*/
'short' 'dim',           8, 16; % /* Data array dimensions.*/  /* short dim[8];        */
'float' 'intent_p1',     1,  4; % /* 1st intent parameter. */  /* short unused8;       */
%                                                              /* short unused9;       */
'float' 'intent_p2',     1,  4; % /* 2nd intent parameter. */  /* short unused10;      */
%                                                              /* short unused11;      */
'float' 'intent_p3',     1,  4; % /* 3rd intent parameter. */  /* short unused12;      */
%                                                              /* short unused13;      */
'short' 'intent_code',   1,  2; % /* NIFTI_INTENT_* code.  */  /* short unused14;      */
'short' 'datatype',      1,  2; % /* Defines data type!    */  /* short datatype;      */
'short' 'bitpix',        1,  2; % /* Number bits/voxel.    */  /* short bitpix;        */
'short' 'slice_start',   1,  2; % /* First slice index.    */  /* short dim_un0;       */
'float' 'pixdim',        8, 32; % /* Grid spacings.        */  /* float pixdim[8];     */
'float' 'vox_offset',    1,  4; % /* Offset into .nii file */  /* float vox_offset;    */
'float' 'scl_slope',     1,  4; % /* Data scaling: slope.  */  /* float funused1;      */
'float' 'scl_inter',     1,  4; % /* Data scaling: offset. */  /* float funused2;      */
'short' 'slice_end',     1,  2; % /* Last slice index.     */  /* float funused3;      */
'int8'  'slice_code',    1,  1; % /* Slice timing order.   */
'int8'  'xyzt_units',    1,  1; % /* Units of pixdim[1..4] */
'float' 'cal_max',       1,  4; % /* Max display intensity */  /* float cal_max;       */
'float' 'cal_min',       1,  4; % /* Min display intensity */  /* float cal_min;       */
'float' 'slice_duration',1,  4; % /* Time for 1 slice.     */  /* float compressed;    */
'float' 'toffset',       1,  4; % /* Time axis shift.      */  /* float verified;      */
'int'   'glmax',         1,  4; % /* ++UNUSED++            */  /* int glmax;           */
'int'   'glmin',         1,  4; % /* ++UNUSED++            */  /* int glmin;           */
                              
%                                                  /*--- was data_history substruct ---*/
'char'  'descrip',      80, 80; % /* any text you like.    */  /* char descrip[80];    */
'char'  'aux_file',     24, 24; % /* auxiliary filename.   */  /* char aux_file[24];   */
                              
'short' 'qform_code',    1,  2; % /* NIFTI_XFORM_* code.   */  /*-- all ANALYZE 7.5 ---*/
'short' 'sform_code',    1,  2; % /* NIFTI_XFORM_* code.   */  /*   fields below here  */
%                                                              /*   are replaced       */
'float' 'quatern_b',     1,  4; % /* Quaternion b param.   */
'float' 'quatern_c',     1,  4; % /* Quaternion c param.   */
'float' 'quatern_d',     1,  4; % /* Quaternion d param.   */
'float' 'qoffset_x',     1,  4; % /* Quaternion x shift.   */
'float' 'qoffset_y',     1,  4; % /* Quaternion y shift.   */
'float' 'qoffset_z',     1,  4; % /* Quaternion z shift.   */
                              
'float' 'srow_x',        4, 16; % /* 1st row affine transform.   */
'float' 'srow_y',        4, 16; % /* 2nd row affine transform.   */
'float' 'srow_z',        4, 16; % /* 3rd row affine transform.   */
                              
'char'  'intent_name',  16, 16; % /*< 'name' or meaning of data.  */
'char'  'magic',         4,  4; % /* MUST be "ni1\0" or "n+1\0". */
};                              % /**** 348 bytes total ****/
end % initialize

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The following code are copied directly from nifti2.h
% 
%                          /***************************/ /**********************/ /************/
% struct nifti_2_header {  /* NIFTI-2 usage           */ /* NIFTI-1 usage      */ /*  offset  */
%                          /***************************/ /**********************/ /************/
%    int   sizeof_hdr;     /*!< MUST be 540           */ /* int sizeof_hdr; (348) */   /*   0 */
%    char  magic[8] ;      /*!< MUST be valid signature. */  /* char magic[4];    */   /*   4 */
%    int16_t datatype;     /*!< Defines data type!    */ /* short datatype;       */   /*  12 */
%    int16_t bitpix;       /*!< Number bits/voxel.    */ /* short bitpix;         */   /*  14 */
%    int64_t dim[8];       /*!< Data array dimensions.*/ /* short dim[8];         */   /*  16 */
%    double intent_p1 ;    /*!< 1st intent parameter. */ /* float intent_p1;      */   /*  80 */
%    double intent_p2 ;    /*!< 2nd intent parameter. */ /* float intent_p2;      */   /*  88 */
%    double intent_p3 ;    /*!< 3rd intent parameter. */ /* float intent_p3;      */   /*  96 */
%    double pixdim[8];     /*!< Grid spacings.        */ /* float pixdim[8];      */   /* 104 */
%    int64_t vox_offset;   /*!< Offset into .nii file */ /* float vox_offset;     */   /* 168 */
%    double scl_slope ;    /*!< Data scaling: slope.  */ /* float scl_slope;      */   /* 176 */
%    double scl_inter ;    /*!< Data scaling: offset. */ /* float scl_inter;      */   /* 184 */
%    double cal_max;       /*!< Max display intensity */ /* float cal_max;        */   /* 192 */
%    double cal_min;       /*!< Min display intensity */ /* float cal_min;        */   /* 200 */
%    double slice_duration;/*!< Time for 1 slice.     */ /* float slice_duration; */   /* 208 */
%    double toffset;       /*!< Time axis shift.      */ /* float toffset;        */   /* 216 */
%    int64_t slice_start;  /*!< First slice index.    */ /* short slice_start;    */   /* 224 */
%    int64_t slice_end;    /*!< Last slice index.     */ /* short slice_end;      */   /* 232 */
%    char  descrip[80];    /*!< any text you like.    */ /* char descrip[80];     */   /* 240 */
%    char  aux_file[24];   /*!< auxiliary filename.   */ /* char aux_file[24];    */   /* 320 */
%    int qform_code ;      /*!< NIFTI_XFORM_* code.   */ /* short qform_code;     */   /* 344 */
%    int sform_code ;      /*!< NIFTI_XFORM_* code.   */ /* short sform_code;     */   /* 348 */
%    double quatern_b ;    /*!< Quaternion b param.   */ /* float quatern_b;      */   /* 352 */
%    double quatern_c ;    /*!< Quaternion c param.   */ /* float quatern_c;      */   /* 360 */
%    double quatern_d ;    /*!< Quaternion d param.   */ /* float quatern_d;      */   /* 368 */
%    double qoffset_x ;    /*!< Quaternion x shift.   */ /* float qoffset_x;      */   /* 376 */
%    double qoffset_y ;    /*!< Quaternion y shift.   */ /* float qoffset_y;      */   /* 384 */
%    double qoffset_z ;    /*!< Quaternion z shift.   */ /* float qoffset_z;      */   /* 392 */
%    double srow_x[4] ;    /*!< 1st row affine transform. */  /* float srow_x[4]; */   /* 400 */
%    double srow_y[4] ;    /*!< 2nd row affine transform. */  /* float srow_y[4]; */   /* 432 */
%    double srow_z[4] ;    /*!< 3rd row affine transform. */  /* float srow_z[4]; */   /* 464 */
%    int slice_code ;      /*!< Slice timing order.   */ /* char slice_code;      */   /* 496 */
%    int xyzt_units ;      /*!< Units of pixdim[1..4] */ /* char xyzt_units;      */   /* 500 */
%    int intent_code ;     /*!< NIFTI_INTENT_* code.  */ /* short intent_code;    */   /* 504 */
%    char intent_name[16]; /*!< 'name' or meaning of data. */ /* char intent_name[16]; */  /* 508 */
%    char dim_info;        /*!< MRI slice ordering.   */      /* char dim_info;        */  /* 524 */
%    char unused_str[15];  /*!< unused, filled with \0 */                                  /* 525 */
% } ;                   /**** 540 bytes total ****/


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent nifti_2_header;
if isempty(nifti_2_header)
% data structure is copied from nifti2.h, with a slightly modification (single char -> int8)
%                                    /***************************/ /**********************/ /************/
nifti_2_header = {%                  /* NIFTI-2 usage           */ /* NIFTI-1 usage      */ /*  offset  */
%                                    /***************************/ /**********************/ /************/
'int'     'sizeof_hdr',     1,  4; % /*!< MUST be 540           */ /* int sizeof_hdr; (348) */   /*   0 */
'char'    'magic',          8,  8; % /*!< MUST be valid signature. */  /* char magic[4];    */   /*   4 */
'int16_t' 'datatype',       1,  2; % /*!< Defines data type!    */ /* short datatype;       */   /*  12 */
'int16_t' 'bitpix',         1,  2; % /*!< Number bits/voxel.    */ /* short bitpix;         */   /*  14 */
'int64_t' 'dim',            8, 64; % /*!< Data array dimensions.*/ /* short dim[8];         */   /*  16 */
'double'  'intent_p1',      1,  8; % /*!< 1st intent parameter. */ /* float intent_p1;      */   /*  80 */
'double'  'intent_p2',      1,  8; % /*!< 2nd intent parameter. */ /* float intent_p2;      */   /*  88 */
'double'  'intent_p3',      1,  8; % /*!< 3rd intent parameter. */ /* float intent_p3;      */   /*  96 */
'double'  'pixdim',         8, 64; % /*!< Grid spacings.        */ /* float pixdim[8];      */   /* 104 */
'int64_t' 'vox_offset',     1,  8; % /*!< Offset into .nii file */ /* float vox_offset;     */   /* 168 */
'double'  'scl_slope',      1,  8; % /*!< Data scaling: slope.  */ /* float scl_slope;      */   /* 176 */
'double'  'scl_inter',      1,  8; % /*!< Data scaling: offset. */ /* float scl_inter;      */   /* 184 */
'double'  'cal_max',        1,  8; % /*!< Max display intensity */ /* float cal_max;        */   /* 192 */
'double'  'cal_min',        1,  8; % /*!< Min display intensity */ /* float cal_min;        */   /* 200 */
'double'  'slice_duration', 1,  8; % /*!< Time for 1 slice.     */ /* float slice_duration; */   /* 208 */
'double'  'toffset',        1,  8; % /*!< Time axis shift.      */ /* float toffset;        */   /* 216 */
'int64_t' 'slice_start',    1,  8; % /*!< First slice index.    */ /* short slice_start;    */   /* 224 */
'int64_t' 'slice_end',      1,  8; % /*!< Last slice index.     */ /* short slice_end;      */   /* 232 */
'char'    'descrip',       80, 80; % /*!< any text you like.    */ /* char descrip[80];     */   /* 240 */
'char'    'aux_file',      24, 24; % /*!< auxiliary filename.   */ /* char aux_file[24];    */   /* 320 */
'int'     'qform_code',     1,  4; % /*!< NIFTI_XFORM_* code.   */ /* short qform_code;     */   /* 344 */
'int'     'sform_code',     1,  4; % /*!< NIFTI_XFORM_* code.   */ /* short sform_code;     */   /* 348 */
'double'  'quatern_b',      1,  8; % /*!< Quaternion b param.   */ /* float quatern_b;      */   /* 352 */
'double'  'quatern_c',      1,  8; % /*!< Quaternion c param.   */ /* float quatern_c;      */   /* 360 */
'double'  'quatern_d',      1,  8; % /*!< Quaternion d param.   */ /* float quatern_d;      */   /* 368 */
'double'  'qoffset_x',      1,  8; % /*!< Quaternion x shift.   */ /* float qoffset_x;      */   /* 376 */
'double'  'qoffset_y',      1,  8; % /*!< Quaternion y shift.   */ /* float qoffset_y;      */   /* 384 */
'double'  'qoffset_z',      1,  8; % /*!< Quaternion z shift.   */ /* float qoffset_z;      */   /* 392 */
'double'  'srow_x',         4, 32; % /*!< 1st row affine transform. */  /* float srow_x[4]; */   /* 400 */
'double'  'srow_y',         4, 32; % /*!< 2nd row affine transform. */  /* float srow_y[4]; */   /* 432 */
'double'  'srow_z',         4, 32; % /*!< 3rd row affine transform. */  /* float srow_z[4]; */   /* 464 */
'int'     'slice_code',     1,  4; % /*!< Slice timing order.   */ /* char slice_code;      */   /* 496 */
'int'     'xyzt_units',     1,  4; % /*!< Units of pixdim[1..4] */ /* char xyzt_units;      */   /* 500 */
'int'     'intent_code',    1,  4; % /*!< NIFTI_INTENT_* code.  */ /* short intent_code;    */   /* 504 */
'char'    'intent_name',   16, 16; % /*!< 'name' or meaning of data. */ /* char intent_name[16]; */  /* 508 */
'int8'    'dim_info',       1,  1; % /*!< MRI slice ordering.   */      /* char dim_info;        */  /* 524 */
'char'    'unused_str',    15, 15; % /*!< unused, filled with \0 */                                  /* 525 */
};                                 % /**** 540 bytes total ****/
end % initialize


if nargin == 2 && byteswap
    func = @swapbytes;
else
    func = @noop;
end

datacast.int     = {'int32',   func};
datacast.int8    = {'int8',    @noop};                      % single char is int8
datacast.char    = {'int8',    @(x) deblank(char(x(:)'))};  % multi char lead to string
datacast.short   = {'int16',   func};
datacast.float   = {'single',  func};
datacast.double  = {'double',  func};
datacast.int16_t = {'int16',   func};
datacast.int64_t = {'int64',   func};


% defination copied from nifti1.h
% #define NIFTI_TYPE_UINT8           2   /*! unsigned char. */
% #define NIFTI_TYPE_INT16           4   /*! signed short. */
% #define NIFTI_TYPE_INT32           8   /*! signed int. */
% #define NIFTI_TYPE_FLOAT32        16   /*! 32 bit float. */
% #define NIFTI_TYPE_COMPLEX64      32   /*! 64 bit complex = 2 32 bit floats. */
% #define NIFTI_TYPE_FLOAT64        64   /*! 64 bit float = double. */
% #define NIFTI_TYPE_RGB24         128   /*! 3 8 bit bytes. */
% #define NIFTI_TYPE_INT8          256   /*! signed char. */
% #define NIFTI_TYPE_UINT16        512   /*! unsigned short. */
% #define NIFTI_TYPE_UINT32        768   /*! unsigned int. */
% #define NIFTI_TYPE_INT64        1024   /*! signed long long. */
% #define NIFTI_TYPE_UINT64       1280   /*! unsigned long long. */
% #define NIFTI_TYPE_FLOAT128     1536   /*! 128 bit float = long double. */
% #define NIFTI_TYPE_COMPLEX128   1792   /*! 128 bit complex = 2 64 bit floats. */
% #define NIFTI_TYPE_COMPLEX256   2048   /*! 256 bit complex = 2 128 bit floats */
% #define NIFTI_TYPE_RGBA32       2304   /*! 4 8 bit bytes. */

tmp = {
   2, 'uint8',  1, 1, @noop;         %/*! unsigned char. */
   4, 'int16',  1, 2, func;          %/*! signed short. */
   8, 'int32',  1, 4, func;          %/*! signed int. */
  16, 'single', 1, 4, func;          %/*! 32 bit float. */
  32, 'single', 2, 8, @(x) unsupported('single complex', x);    %/*! 64 bit complex = 2 32 bit floats. */
  64, 'double', 1, 8, func;          %/*! 64 bit float = double. */
 128, 'uint8',  3, 3, @(x) unsupported('rgb', x);               %/*! 3 8 bit bytes. */
 256, 'int8',   1, 1, @noop;         %/*! signed char. */
 512, 'uint16', 1, 2, func;          %/*! unsigned short. */
 768, 'uint32', 1, 4, func;          %/*! unsigned int. */
1024, 'int64',  1, 8, func;          %/*! signed long long. */
1280, 'uint64', 1, 8, func;          %/*! unsigned long long. */
1536, 'double', 1,16, @(x) unsupported('long double', x);       %/*! 128 bit float = long double. Unsupported!! */
1792, 'double', 2,16, @(x) unsupported('double complex', x);    %/*! 128 bit complex = 2 64 bit floats. */
2048, 'double', 2,32, @(x) unsupported('long complex', x);      %/*! 256 bit complex = 2 128 bit floats, Unsupported! */
2304, 'uint8',  4, 4, @(x) unsupported('rgba', x);              %/*! 4 8 bit bytes. */
};
datatype = containers.Map('KeyType', 'double', 'ValueType', 'Any');
for ii = 1: size(tmp, 1)
    datatype(tmp{ii, 1}) = tmp(ii, 2:end);
end


switch version
    case {'nifti1', 'ni1', 'n+1'}
        st = nifti_1_header;
    case {'nifti2', 'ni2', 'n+2'}
        st = nifti_2_header;
    otherwise
        error('Unknown Nifti flavor %s.', version);
end

end % function


function x = noop(x)
end

function unsupported(type, ~)
error('Data type %s not yet supportted.', type);
end
