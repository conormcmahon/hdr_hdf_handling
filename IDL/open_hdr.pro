
; *** OPEN_HDR ***
; Used to open annoying images coupled to .HDR header files
; Automatically handles getting image size from header to prevent array breaking
; Assumes image and header file have the same name and path, but that header appends .HDR suffix
; * Arguments *
;     PATH - system path to target file (do not append filetype prefix)
;     FILEIND - index to be used for file handling
; * Outputs *
;     IMG - actual raster image type with output data - outputs fltarr with structure [SCANS, BANDS, LINES]
;     NS - number of scans (extracted from .HDR header file)
;     NL - number of lines (extracted from .HDR header file)
;     BANDS - number of bands (extracted from .HDR header file)

pro open_hdr, path, fileind, img, ns, nl, bands
  
  close,fileind
  openr,fileind,path + ".hdr"
  
  ; Read information from .HDR header file
  header_lines = strarr(6)
  readf,fileind,header_lines
  close,fileind
  
  ; Extract the number of samples
  ns = long((strsplit(header_lines[3], "= ", /extract))[1])
  ; Extract the number of lines
  nl = long((strsplit(header_lines[4], "= ", /extract))[1])
  ; Extract the number of bands
  bands = long((strsplit(header_lines[5], "= ", /extract))[1])
  
  ; Actually read in the image raster data!
  img = fltarr(ns,bands,nl)
  openr,fileind,path
  readu,fileind,img
  close,fileind
  
end